part of 'Controllers.dart';

class MahasiswaController {
  //Function Menambah Mahasiswa
  Future<void> AddMahasiswaTombol(
      XFile picture, String Nama_Mahasiswa, BuildContext context) async {
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
    var response = await ApiServices.postMahasiswa(imageBytes, Nama_Mahasiswa);

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

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

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

  //Fungsi Edit Mahasiswa
  Future<void> EditMahasiswaTombol(XFile picture, String Nama_Mahasiswa,
      int Mahasiswa_Id, BuildContext context) async {
    print("Debug Nama Update Mahasiswa: " + Nama_Mahasiswa);
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
    var response = await ApiServices.updateMahasiswa(
        imageBytes, Nama_Mahasiswa, Mahasiswa_Id);

    // Hide loading indicator
    Navigator.pop(context);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Homepage(key: UniqueKey())));

    return response;
  }
}
