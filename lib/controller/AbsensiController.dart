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
      Fluttertoast.showToast(
          msg: "Absensi Berhasil Dicatat",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14);
      print(response); // Or show a success dialog
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else if (response.statusCode == 422) {
      Fluttertoast.showToast(
          msg: "No Face is detected",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14);
      // Hide loading indicator
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Error Input Absensi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14);
      // Hide loading indicator
      Navigator.pop(context);
    }
  }
}
