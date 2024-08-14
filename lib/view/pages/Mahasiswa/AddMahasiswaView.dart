part of '../Pages.dart';

class AddMahasiswaView extends StatefulWidget {
  const AddMahasiswaView({Key? key}) : super(key: key);

  @override
  _AddMahasiswaViewState createState() => _AddMahasiswaViewState();
}

class _AddMahasiswaViewState extends State<AddMahasiswaView> {
  //Controller
  final ctrlName = TextEditingController(); //Text Field Input Nama
  late CameraController cameraController; //Camera Controller
  MahasiswaController mahasiswaController =
      MahasiswaController(); //MahasiswaController

  //Variable
  bool _showCameraPreview = false; //Boolean tombol camera
  XFile? picture; //File ambil foto

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
          //App Bar
          appBar: AppBar(
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
          ),

          body: Column(
            children: [
              //Kotak Abu2
              Expanded(
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
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),

                    //Form Nama dan Foto
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          child: Column(
                            children: [
                              //Input Nama
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "Mahasiswa Name",
                                ),
                                controller: ctrlName,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => value.toString().isEmpty
                                    ? 'Please fill in the blank!'
                                    : null,
                              ),

                              SizedBox(
                                height: 16,
                              ),

                              //Tombol Open Camera
                              ElevatedButton.icon(
                                onPressed: () async {
                                  // Dismiss the keyboard
                                  FocusScope.of(context).unfocus();

                                  setState(() {
                                    _showCameraPreview =
                                        true; // Show camera preview on button press
                                  });
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors
                                      .white, // Change the color of the icon to white
                                ),
                                label: Text(
                                  'Capture Image',
                                  style: TextStyle(
                                      color: Colors
                                          .white), // Change the color of the text to white
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),

                              //Menunjukan Gambar Apabila foto sudah diambil
                              picture != null
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                onPressed: () {
                                  if (ctrlName.text.toString() == "") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("There is an Error!"),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Please fill in the blanks!"),
                                            ]),
                                      ),
                                    );
                                  } else {
                                    if (mounted) {
                                      //Function untuk menambah maahasiswa baru
                                      if (mahasiswaController
                                              .AddMahasiswaTombol(
                                                  picture!,
                                                  ctrlName.text,
                                                  this.context) !=
                                          null) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Mahasiswa Berhasil Ditambahkan",
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
              )
            ],
          ),
        ),

        //Tampilan Camera Preview
        _showCameraPreview
            ? Container(
                // Set a white background color
                color: Colors.white,
                child: Stack(
                  children: [
                    // Existing CameraPreview widget
                    CameraPreview(cameraController),

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
                            _showCameraPreview = false;
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
                              _showCameraPreview = false;
                            });
                          },
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    );
  }

  //Function untuk mengambil foto
  Future<void> _takePicture() async {
    try {
      await cameraController.takePicture().then((image) {
        picture = image;
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
