part of '../Pages.dart';

class EditKelas extends StatefulWidget {
  final Kelas kelas;
  const EditKelas(this.kelas);

  @override
  _EditKelasState createState() => _EditKelasState();
}

class _EditKelasState extends State<EditKelas> {
  final ctrlName = TextEditingController();
  final ctrlLocation = TextEditingController();
  List<Mahasiswa> selectedmahasiswaList = [];
  List<Mahasiswa> selectedmahasiswaListBaru = [];
  List<Mahasiswa> MahasiswaList = [];
  List<KelasMahasiswa> KelasMahasiswaList = [];

  Future<List<Mahasiswa>> getMahasiswaByKelasId(int Kelas_Id) async {
    List<Mahasiswa> mahasiswaList = []; // Initialize as an empty list
    await ApiServices.getMahasiswaByKelasId(Kelas_Id).then((value) {
      mahasiswaList = value;
      selectedmahasiswaList = value;
    });
    return mahasiswaList; // return the list here
  }

  Future<void> GetMahasiswa() async {
    await ApiServices.getMahasiswa().then((value) {
      setState(() {
        MahasiswaList = value;
      });
    });

    Future<void> getKelasMahasiswaByKelasId(int Kelas_Id) async {
      await ApiServices.getKelasMahasiswabyId(Kelas_Id).then((value) {
        setState(() {
          KelasMahasiswaList = value;
        });
      });
      print(KelasMahasiswaList.toString());
    }
  }

  void compareAndDeleteKelasMahasiswa(List<Mahasiswa> selectedMahasiswaList,
      List<Mahasiswa> selectedMahasiswaListBaru) async {
    // Find mahasiswa IDs in selectedmahasiswaList but not in selectedmahasiswaListBaru
    List<int> mahasiswaIdsToDelete = selectedMahasiswaList
        .where((mhs) => !selectedMahasiswaListBaru
            .any((mhsBaru) => mhs.Mahasiswa_Id == mhsBaru.Mahasiswa_Id))
        .map((mhs) => mhs.Mahasiswa_Id)
        .toList();

    // Loop through each mahasiswa ID and delete the corresponding KelasMahasiswa
    for (int mahasiswaId in mahasiswaIdsToDelete) {
      await DeleteKelasMahasiswa(findKelasMahasiswaIdByMahasiswaId(
          mahasiswaId, widget.kelas.Kelas_Id));
    }
  }

  // Helper function to find KelasMahasiswa ID based on Mahasiswa ID (assuming a function to fetch KelasMahasiswa by Mahasiswa ID exists)
  int findKelasMahasiswaIdByMahasiswaId(int mahasiswaId, int Kelas_Id) {
    for (var i = 0; i < KelasMahasiswaList.length; i++) {
      if (KelasMahasiswaList[i].Kelas_Id == Kelas_Id &&
          KelasMahasiswaList[i].Mahasiswa_Id == mahasiswaId) {
        return KelasMahasiswaList[i].Kelas_Id;
      }
    }
    return -1;
  }

  Future<dynamic> EditKelas(
      int Kelas_Id,
      String Kelas_Nama,
      String Kelas_Lokasi,
      List<Mahasiswa> selectedMahasiswaList,
      List<Mahasiswa> selectedMahasiswaListBaru) async {
    dynamic response = true;
    await ApiServices.updateKelas(Kelas_Id, Kelas_Nama, Kelas_Lokasi);
    compareAndDeleteKelasMahasiswa(
        selectedMahasiswaList, selectedMahasiswaListBaru);
    // Create a new GlobalKey
    var key = GlobalKey<_HomeState>();
    Navigator.pushReplacement(
        this.context, MaterialPageRoute(builder: (context) => Home(key: key)));
    return response;
  }

  Future<dynamic> DeleteKelasMahasiswa(int KelasMahasiswa_Id) async {
    dynamic response = true;

    // Wait for the deletion operation to complete
    await ApiServices.deleteKelasMahasiswa(KelasMahasiswa_Id);

    return response;
  }

  Widget buildMultiSelectField(
      List<Mahasiswa> selectedmahasiswaList, List<Mahasiswa> mahasiswaList) {
    return MultiSelectDialogField(
      items: mahasiswaList
          .map((e) => MultiSelectItem(e, e.Mahasiswa_Nama))
          .toList(),
      listType: MultiSelectListType.CHIP,
      initialValue:
          selectedmahasiswaList, // Set initial value directly if data is passed
      onConfirm: (values) {
        selectedmahasiswaListBaru = values.cast<Mahasiswa>();
      },
    );
  }

  @override
  void dispose() {
    ctrlName.dispose();
    ctrlLocation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    GetMahasiswa();
    getMahasiswaByKelasId(widget.kelas.Kelas_Id);
    ctrlName.text = widget.kelas.Kelas_Nama;
    ctrlLocation.text = widget.kelas.Kelas_Lokasi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: new Icon(Icons.arrow_back_ios_rounded));
          }),
          title: Text(
            "Edit Kelas",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        //Body
        body: Column(
          children: [
            //Bottom Sheet
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
                        child: Column(children: [
                          //Text Field Class Name
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Class Name",
                            ),
                            controller: ctrlName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.toString().isEmpty
                                  ? 'Please fill in the blank!'
                                  : null;
                            },
                          ),

                          SizedBox(
                            height: 16,
                          ),

                          //Text Field Class Location
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Class Location",
                            ),
                            controller: ctrlLocation,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.toString().isEmpty
                                  ? 'Please fill in the blank!'
                                  : null;
                            },
                          ),

                          SizedBox(
                            height: 16,
                          ),

                          FutureBuilder<List<Mahasiswa>>(
                            future:
                                getMahasiswaByKelasId(widget.kelas.Kelas_Id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return buildMultiSelectField(
                                    snapshot.data ?? [], MahasiswaList);
                              }
                            },
                          ),

                          SizedBox(
                            height: 32,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (ctrlName.text.toString() == "" ||
                                  ctrlLocation.text.toString() == "") {
                                showDialog(
                                    context: context,
                                    builder: ((((context) {
                                      return AlertDialog(
                                        title: Text("There is an Error!"),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Please fill in the blanks!"),
                                            ]),
                                      );
                                    }))));
                              } else {
                                if (EditKelas(
                                        widget.kelas.Kelas_Id,
                                        ctrlName.text.toString(),
                                        ctrlLocation.text.toString(),
                                        selectedmahasiswaList,
                                        selectedmahasiswaListBaru) !=
                                    null) {
                                  Fluttertoast.showToast(
                                      msg: "Kelas Berhasil Diedit",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 14);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Kelas Gagal Diedit",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 14);
                                }
                              }
                            },
                            child: const Text(
                              'SAVE',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
