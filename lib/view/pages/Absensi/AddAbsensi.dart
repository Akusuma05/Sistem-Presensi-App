part of '../Pages.dart';

class AddAbsensi extends StatefulWidget {
  const AddAbsensi({Key? key}) : super(key: key);

  @override
  _AddAbsensiState createState() => _AddAbsensiState();
}

class _AddAbsensiState extends State<AddAbsensi> with WidgetsBindingObserver {
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: CameraPreview(cameraController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50.0), // Adjust as needed
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 30.0), // Adjust as needed
                child: InkWell(
                  onTap: () async {
                    if (!cameraController.value.isInitialized) {
                      return null;
                    }
                    if (cameraController.value.isTakingPicture) {
                      return null; // Prevent multiple captures while processing
                    }
                    try {
                      await cameraController.setFlashMode(FlashMode.off);
                      XFile picture = await cameraController.takePicture();
                      // Navigate to ImagePreview screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagePreview(picture),
                        ),
                      );
                    } on CameraException catch (e) {
                      debugPrint("Error occured while taking picture : $e");
                      return null;
                    }
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  // Set highlight and splash color for visual feedback
                  highlightColor: Colors.redAccent.withOpacity(0.7),
                  splashColor: Colors.redAccent.withOpacity(0.3),
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
