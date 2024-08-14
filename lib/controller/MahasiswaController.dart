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
      Fluttertoast.showToast(
          msg: "Detected Faces: $detectedFaces",
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      Fluttertoast.showToast(
          msg: "Error Input Absensi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14);
      // Hide loading indicator
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
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
