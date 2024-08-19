part of '../Pages.dart';

class AddMahasiswaView extends StatefulWidget {
  const AddMahasiswaView({Key? key}) : super(key: key);

  @override
  _AddMahasiswaViewState createState() => _AddMahasiswaViewState();
}

class _AddMahasiswaViewState extends State<AddMahasiswaView> {
  //Controller
  final ctrlName = TextEditingController(); //Text Field Input Nama
  final ctrlNIM = TextEditingController(); //Text Field Input Nama
  late CameraController cameraController; //Camera Controller
  MahasiswaController mahasiswaController =
      MahasiswaController(); //MahasiswaController

  //Variable
  bool showCameraPreview = false; //Boolean tombol camera
  XFile? mahasiswaFoto; //File ambil foto

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: _buildBottomSheet(),
        ),

        //Tampilan Camera Preview
        showCameraPreview ? _buildCameraView() : SizedBox(),
      ],
    );
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      //Tombol Back
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded));
      }),

      //Judul App Bar
      title: Text(
        "Add Mahasiswa",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  //Build UI Bottom Sheet
  Expanded _buildBottomSheet() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),

            //Form Nama dan Foto
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Mahasiswa NIM",
                        ),
                        controller: ctrlNIM,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value.toString().isEmpty
                            ? 'Please fill in the blank!'
                            : null,
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      //Input Nama
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Mahasiswa Name",
                        ),
                        controller: ctrlName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value.toString().isEmpty
                            ? 'Please fill in the blank!'
                            : null,
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      _buildOpenCameraButton(),

                      SizedBox(
                        height: 16,
                      ),

                      //Menunjukan Gambar Apabila foto sudah diambil
                      mahasiswaFoto != null
                          ? Container(
                              height: MediaQuery.of(context).size.height *
                                  0.5, // 20% of screen height
                              child: Image.file(
                                File(mahasiswaFoto!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(),

                      SizedBox(
                        height: 32,
                      ),

                      //Tombol Submit
                      ElevatedButton(
                        onPressed: () async {
                          if (ctrlName.text.toString() == "" ||
                              ctrlNIM.text.toString() == "") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("There is an Error!"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Please fill in the blanks!"),
                                    ]),
                              ),
                            );
                          } else {
                            if (mounted) {
                              dynamic response =
                                  await mahasiswaController.AddMahasiswaTombol(
                                      mahasiswaFoto!,
                                      ctrlNIM.text,
                                      ctrlName.text,
                                      this.context);
                              if (response.statusCode == 201) {
                                Fluttertoast.showToast(
                                    msg: "Mahasiswa Berhasil Ditambahkan",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 14);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Penambahan Mahasiswa Gagal",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14);
                              }
                            }
                          }
                        },

                        //Tombol Submit
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Build UI CameraView
  Container _buildCameraView() {
    return Container(
      // Set a white background color
      color: Colors.white,
      child: Stack(
        children: [
          // Existing CameraPreview widget
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Container(
                    width: cameraController.value.previewSize!
                        .width, // the actual width is not important here
                    child: CameraPreview(cameraController)),
              )),

          // Existing Close Button
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  showCameraPreview = false;
                });
              },
            ),
          ),

          // Existing Capture Button (Optional)
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () async {
                  await _takePicture();
                  setState(() {
                    showCameraPreview = false;
                  });
                },
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildOpenCameraButton() {
    //Tombol Open Camera
    return ElevatedButton.icon(
      onPressed: () async {
        // Dismiss the keyboard
        FocusScope.of(context).unfocus();

        setState(() {
          showCameraPreview = true; // Show camera preview on button press
        });
      },
      icon: Icon(
        Icons.camera_alt_outlined,
        color: Colors.white, // Change the color of the icon to white
      ),
      label: Text(
        'Capture Image',
        style: TextStyle(
            color: Colors.white), // Change the color of the text to white
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
      ),
    );
  }

  //Take Picture
  //Function untuk mengambil foto
  Future<void> _takePicture() async {
    try {
      await cameraController.takePicture().then((image) {
        mahasiswaFoto = image;
        setState(() {});
      });
    } on CameraException catch (e) {
      print(e);
    }
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
