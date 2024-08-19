part of '../Pages.dart';

class AddAbsensi extends StatefulWidget {
  final int Kelas_Id;
  const AddAbsensi(this.Kelas_Id);

  @override
  _AddAbsensiState createState() => _AddAbsensiState();
}

class _AddAbsensiState extends State<AddAbsensi> with WidgetsBindingObserver {
  late CameraController cameraController; //Controller Camera
  AbsensiController absensiController =
      AbsensiController(); //Controller Absensi

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
                width: cameraController.value.previewSize!
                    .width, // the actual width is not important here
                child: CameraPreview(cameraController)),
          )), //Camera Preview
      //Tombol Camera
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
                //Kirim Gambar ke API untuk Absensi
                XFile? image = await cameraController.takePicture();
                await absensiController.AddAbsensiButton(
                    widget.Kelas_Id, image, this.context);
              },
            ),
          ),
        ],
      ),
    );
  }

  //Initialisasi Kamera
  void initCamera() {
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
}
