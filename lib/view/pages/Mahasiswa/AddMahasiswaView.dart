part of '../Pages.dart';

class AddMahasiswaView extends StatefulWidget {
  const AddMahasiswaView({Key? key}) : super(key: key);

  @override
  _AddMahasiswaViewState createState() => _AddMahasiswaViewState();
}

class _AddMahasiswaViewState extends State<AddMahasiswaView> {
  final ctrlName = TextEditingController();
  XFile? picture; // Variable to store the captured image
  late CameraController cameraController; // Camera controller instance
  bool _showCameraPreview = false;

  @override
  void initState() {
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
          appBar: AppBar(
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_rounded));
            }),
            title: Text(
              "Add Mahasiswa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          // This Form widget should be closed here
                          child: Column(
                            children: [
                              // Text Field Class Name
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
                                      if (_handleImageCapture(
                                              picture!, ctrlName.text) !=
                                          null) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Mahasiswa Berhasil Ditambahkan",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
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
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors
                                          .white), // Change the color of the text to white
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .black, // Change the color of the button to black
                                ),
                              ),
                            ],
                          ), // This Form widget should be closed here
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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

  Future<void> _handleImageCapture(XFile picture, String Nama_Mahasiswa) async {
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

    return response;
  }
}
