part of '../Pages.dart';

class EditMahasiswa extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const EditMahasiswa(this.mahasiswa);

  @override
  _EditMahasiswaState createState() => _EditMahasiswaState();
}

class _EditMahasiswaState extends State<EditMahasiswa> {
  final ctrlName = TextEditingController();
  late CameraController cameraController;
  MahasiswaController mahasiswaController = MahasiswaController();
  bool showCameraPreview = false;
  XFile? picture;

  @override
  void initState() {
    ctrlName.text = widget.mahasiswa.Mahasiswa_Nama;
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
        showCameraPreview ? _buildCameraPage() : SizedBox(),
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

      //Judul AppBar
      title: Text(
        "Edit Mahasiswa",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  //Build UI Bottom Sheet
  Expanded _buildBottomSheet() {
    return Expanded(
      child: Container(
        //Bottom Sheet
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
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Form Edit Mahasiswa
                Form(
                  child: Column(
                    children: [
                      // Text Field Nama Mahasiswa
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

                      //Tombol Buka Kamera
                      _buildOpenCameraButton(),

                      SizedBox(
                        height: 16,
                      ),

                      //Menampilkan Gambar Apabila Foto sudah diambil
                      picture != null
                          ? Container(
                              height: MediaQuery.of(context).size.height *
                                  0.5, // 20% of screen height
                              child: Image.file(
                                File(picture!.path),
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
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                          if (ctrlName.text.toString() == "") {
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
                              dynamic response = await updateMahasiswa(
                                  picture,
                                  ctrlName.text.toString(),
                                  widget.mahasiswa.Mahasiswa_Id);
                              //Function Save Mahasiswa
                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Homepage(key: UniqueKey())));
                                Fluttertoast.showToast(
                                    msg: "Mahasiswa Berhasil Diedit",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 14);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Edit Mahasiswa Gagal",
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

  ElevatedButton _buildOpenCameraButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        // Dismiss the keyboard
        FocusScope.of(context).unfocus();

        setState(() {
          showCameraPreview = true;
        });
      },
      icon: Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
      ),
      label: Text(
        'Capture Image',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
      ),
    );
  }

  Container _buildCameraPage() {
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
                    width: 100, // the actual width is not important here
                    child: CameraPreview(cameraController!)),
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

  //Function Ambil Foto
  Future<void> _takePicture() async {
    try {
      await cameraController.takePicture().then((image) {
        picture = image;
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

  //Update Mahasiswa
  //Function untuk memanggil hasil response dari MahasiswaController dengan mahasiswaFoto, mahasiswaNama, mahasiswaId
  Future<dynamic> updateMahasiswa(
      XFile? mahasiswaFoto, String mahasiswaNama, int mahasiswaId) async {
    dynamic response = await mahasiswaController.updateMahasiswa(
        mahasiswaFoto, mahasiswaNama, mahasiswaId);
    print("DEBUG EditMahasiswa updateMahasiswa: " +
        response.statusCode.toString());
    return response;
  }
}
