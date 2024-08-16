part of 'Controllers.dart';

class AbsensiController {
  //Add Absensi
  Future<void> AddAbsensiButton(
      int Kelas_Id, XFile picture, BuildContext context) async {
    print(Kelas_Id);
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
    var response = await ApiServices.postAbsensi(imageBytes, Kelas_Id);

    // Hide loading indicator
    Navigator.pop(context);

    // Handle API response
    if (response.statusCode == 201) {
      var detectedFaces =
          (jsonDecode(response.body)["Detected Faces"] as List).join(", ");
      var JumlahDetected =
          (jsonDecode(response.body)["Detected Faces"] as List).length;
      String MessageDetectedFace =
          "$JumlahDetected Detected Faces: $detectedFaces";

      var BerhasilTercatat =
          (jsonDecode(response.body)["Present Mahasiswa"] as List).join(", ");
      var JumlahBerhasil =
          (jsonDecode(response.body)["Present Mahasiswa"] as List).length;
      String MessagePresentMahasiswa =
          "$JumlahBerhasil Faces Recorded: $BerhasilTercatat";

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Absensi Berhasil Dicatat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(MessageDetectedFace),
              Text(MessagePresentMahasiswa)
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Homepage())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 422) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Face is detected'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Homepage())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error Input Absensi'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Homepage())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
