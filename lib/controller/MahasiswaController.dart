part of 'Controllers.dart';

class MahasiswaController {
  //Function Get Mahasiswa
  //Function memanggil function getMahasiswa dari APIService dan return hasil response API
  Future<List<Mahasiswa>> getMahasiswa() async {
    final response = await ApiServices.getMahasiswa();
    print("DEBUG MahasiswaController getMahasiswa: mahasiswaList length " +
        response.length.toString());
    return response;
  }

  //Function Delete Mahasiswa
  //Function memanggil function deleteMahasiswa berdasarkan mahasiswaId dari APIService dan return hasil response API
  Future<dynamic> deleteMahasiswa(int mahasiswaId) async {
    final response = await ApiServices.deleteMahasiswa(mahasiswaId);
    print("DEBUG MahasiswaController deleteMahasiswa: " +
        response.statusCode.toString());
    return response;
  }

  //Function Update Mahasiswa
  //Function memanggil function updateMahasiswa untuk update mahasiswaFoto, mahasiswaNama, mahasiswaId berdasarkan mahasiswaId dari APIService dan return hasil response API
  Future<dynamic> updateMahasiswa(XFile? mahasiswaFoto, String mahasiswaNama,
      int mahasiswaId, int mahasiswaNIM) async {
    if (mahasiswaFoto == null) {
      final response = await ApiServices.updateMahasiswa(
          null, mahasiswaNama, mahasiswaId, mahasiswaNIM);
      print("DEBUG MahasiswaController updateMahasiswa: " +
          response.statusCode.toString());
      return response;
    } else {
      final fileFoto = await File(mahasiswaFoto.path);
      final response = await ApiServices.updateMahasiswa(
          fileFoto, mahasiswaNama, mahasiswaId, mahasiswaNIM);
      print("DEBUG MahasiswaController updateMahasiswa: " +
          response.statusCode.toString());
      return response;
    }
  }

  //Function Menambah Mahasiswa
  Future<dynamic> AddMahasiswaTombol(XFile picture, String mahasiswaNIM,
      String mahasiswaNama, BuildContext context) async {
    // Read the captured image file
    final imageBytes = await File(picture.path);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Call postAbsensi to send the image and class ID
    var response = await ApiServices.postMahasiswa(
        imageBytes, mahasiswaNIM, mahasiswaNama);

    // Hide loading indicator
    Navigator.pop(context);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Homepage(key: UniqueKey())));

    return response;
  }

  //Function Deteksi Mahasiswa
  Future<void> DeteksiMahasiswaTombol(
      XFile picture, BuildContext context) async {
    // Read the captured image file
    final imageBytes = await File(picture.path);

    // Call postAbsensi to send the image and class ID
    var response = await ApiServices.deteksiMahasiswa(imageBytes);

    // Hide loading indicator
    Navigator.pop(context);

    // Handle API response
    if (response.statusCode == 202) {
      var detectedFaces =
          (jsonDecode(response.body)["Detected Faces"] as List).join(", ");

      String formattedMessage = "Detected Faces: $detectedFaces";

      print(response); // Or show a success dialog

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Face Detected'),
          content: Text(formattedMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 422) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Face Detected'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error Input Absensi Or Server Internal Error'),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
