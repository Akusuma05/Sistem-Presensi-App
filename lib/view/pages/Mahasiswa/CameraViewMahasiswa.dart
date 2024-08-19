part of '../Pages.dart';

class CameraViewMahasiswa extends StatefulWidget {
  const CameraViewMahasiswa({Key? key}) : super(key: key);

  @override
  _CameraViewMahasiswaState createState() => _CameraViewMahasiswaState();
}

class _CameraViewMahasiswaState extends State<CameraViewMahasiswa> {
  late CameraController cameraController; //Controller Camera
  MahasiswaController mahasiswaController = MahasiswaController();

  @override
  void initState() {
    initCamera();
    super.initState();
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
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
                width: cameraController.value.previewSize!.width,
                child: CameraPreview(cameraController)),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt),
              onPressed: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(child: CircularProgressIndicator());
                  },
                );
                XFile? image = await cameraController.takePicture();
                await mahasiswaController.DeteksiMahasiswaTombol(
                    image, this.context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.setFlashMode(FlashMode.off);
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
}
