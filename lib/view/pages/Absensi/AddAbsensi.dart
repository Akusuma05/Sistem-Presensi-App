part of '../Pages.dart';

class AddAbsensi extends StatefulWidget {
  final int Kelas_Id;
  const AddAbsensi(this.Kelas_Id);

  @override
  _AddAbsensiState createState() => _AddAbsensiState();
}

class _AddAbsensiState extends State<AddAbsensi> with WidgetsBindingObserver {
  late CameraController cameraController;
  late CameraDescription backCamera, frontCamera;

  @override
  void initState() {
    super.initState();
    // getAvailableCamera();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CameraPreview(cameraController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt),
              onPressed: () async {
                XFile? image = await cameraController.takePicture();
                if (image != null) {
                  await _handleImageCapture(image);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageCapture(XFile picture) async {
    print(widget.Kelas_Id);
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
    var response = await ApiServices.postAbsensi(imageBytes, widget.Kelas_Id);

    // Hide loading indicator
    Navigator.pop(context);

    // Handle API response
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "Kelas Berhasil Ditambahkan",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14);
      print(response); // Or show a success dialog
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
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
