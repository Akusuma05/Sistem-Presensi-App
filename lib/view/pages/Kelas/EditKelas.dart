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
  final ctrlKelasIdvarchar = TextEditingController();

  final MultiSelectController mahasiswaSelectController =
      MultiSelectController();

  List<Mahasiswa> selectedmahasiswaList = [];
  List<Mahasiswa> selectedmahasiswaListBaru = [];
  List<Mahasiswa> MahasiswaList = [];
  List<KelasMahasiswa> KelasMahasiswaList = [];

  @override
  void dispose() {
    ctrlName.dispose();
    ctrlLocation.dispose();
    ctrlKelasIdvarchar.dispose();
    MahasiswaList = [];
    selectedmahasiswaListBaru = [];
    super.dispose();
  }

  @override
  void initState() {
    GetMahasiswa();
    getMahasiswaByKelasId(widget.kelas.Kelas_Id);
    getKelasMahasiswaByKelasId(widget.kelas.Kelas_Id);
    ctrlName.text = widget.kelas.Kelas_Nama;
    ctrlLocation.text = widget.kelas.Kelas_Lokasi;
    ctrlKelasIdvarchar.text = widget.kelas.Kelas_Id_varchar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        //AppBar
        appBar: _buildAppBar(),
        //Body
        body: _buildBottomSheet());
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue.shade100,
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
    );
  }

  //Build UI Bottom Sheet
  Padding _buildBottomSheet() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                  Form(
                    child: Column(children: [
                      //Text Field Class Id
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Class Id",
                        ),
                        controller: ctrlKelasIdvarchar,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value.toString().isEmpty
                              ? 'Please fill in the blank!'
                              : null;
                        },
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      buildMultiSelectField(),

                      SizedBox(
                        height: 8,
                      ),

                      //Text Field Class Name
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Class Name",
                        ),
                        controller: ctrlName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value.toString().isEmpty
                              ? 'Please fill in the blank!'
                              : null;
                        },
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (ctrlName.text.toString() == "" ||
                              ctrlLocation.text.toString() == "" ||
                              ctrlKelasIdvarchar.text.toString() == "") {
                            showDialog(
                                context: context,
                                builder: ((((context) {
                                  return AlertDialog(
                                    title: Text("There is an Error!"),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Please fill in the blanks!"),
                                        ]),
                                  );
                                }))));
                          } else {
                            dynamic response = await EditKelas(
                                widget.kelas.Kelas_Id,
                                ctrlName.text.toString(),
                                ctrlLocation.text.toString(),
                                ctrlKelasIdvarchar.text.toString(),
                                selectedmahasiswaList,
                                mahasiswaSelectController.selectedOptions);
                            if (response == true) {
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
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffACC196),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Mahasiswa>> getMahasiswaByKelasId(int Kelas_Id) async {
    List<Mahasiswa> mahasiswaList = []; // Initialize as an empty list
    await ApiServices.getMahasiswaByKelasId(Kelas_Id).then((value) {
      mahasiswaList = value;
      selectedmahasiswaList = value;
      selectedmahasiswaListBaru = value;
    });
    return mahasiswaList; // return the list here
  }

  Future<void> GetMahasiswa() async {
    await ApiServices.getMahasiswa().then((value) {
      setState(() {
        MahasiswaList = value;
      });
    });
  }

  Future<void> getKelasMahasiswaByKelasId(int Kelas_Id) async {
    await ApiServices.getKelasMahasiswabyId(Kelas_Id).then((value) {
      setState(() {
        KelasMahasiswaList = value;
      });
    });
    print(KelasMahasiswaList.toString());
  }

  Future<dynamic> EditKelas(
      int Kelas_Id,
      String Kelas_Nama,
      String Kelas_Lokasi,
      String Kelas_Id_varchar,
      List<Mahasiswa> selectedMahasiswaList,
      List<ValueItem> selectedMahasiswaListBaru) async {
    dynamic response = await ApiServices.updateKelas(
        Kelas_Id, Kelas_Nama, Kelas_Lokasi, Kelas_Id_varchar);
    dynamic responseKelasMahasiswa = await compareAndDeleteKelasMahasiswa(
        selectedMahasiswaList, selectedMahasiswaListBaru);
    // Create a new GlobalKey
    var key = GlobalKey<_HomeState>();
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) => Homepage(key: key)));

    if (response.statusCode == 200 || responseKelasMahasiswa == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> DeleteKelasMahasiswa(int KelasMahasiswa_Id) async {
    dynamic response = true;

    // Wait for the deletion operation to complete
    await ApiServices.deleteKelasMahasiswa(KelasMahasiswa_Id);

    return response;
  }

  Future<dynamic> compareAndDeleteKelasMahasiswa(
    List<Mahasiswa> selectedMahasiswaList,
    List<ValueItem> selectedMahasiswaListBaru,
  ) async {
    bool success = true;
    // Find mahasiswa IDs in selectedMahasiswaList but not in selectedMahasiswaListBaru
    print(selectedMahasiswaList);
    print(selectedMahasiswaListBaru);

    // Convert the new list of students to a set for efficient lookup
    final existingIds = selectedMahasiswaListBaru
        .map((item) => item.value != null ? int.parse(item.value!) : null)
        .where((id) => id != null)
        .toSet(); // Assuming 'value' in ValueItem holds the Mahasiswa_Id

    // Create a list to store the IDs of the students to delete
    List<int> mahasiswaIdsToDelete = [];

    // Iterate over the original list and add students who are not in the new list to mahasiswaIdsToDelete
    for (var mahasiswa in selectedMahasiswaList) {
      if (!existingIds.contains(mahasiswa.Mahasiswa_Id)) {
        mahasiswaIdsToDelete.add(mahasiswa.Mahasiswa_Id);
      }
    }

    // Now mahasiswaIdsToDelete contains the IDs of the students to delete
    print("IDs of Mahasiswa to delete: $mahasiswaIdsToDelete");

    // Loop through each mahasiswa ID and delete the corresponding KelasMahasiswa
    for (int mahasiswaId in mahasiswaIdsToDelete) {
      print("Debug Mahasiswa_ID Delete: " + mahasiswaId.toString());
      print("Debug Kelas_ID Delete: " + widget.kelas.Kelas_Id.toString());
      await DeleteKelasMahasiswa(findKelasMahasiswaIdByMahasiswaId(
          mahasiswaId, widget.kelas.Kelas_Id));
    }

    // Create a list to store the IDs of the students to add
    List<int> mahasiswaIdsToAdd = [];

    // Convert the original list of students to a set for efficient lookup
    final originalIds = selectedMahasiswaList
        .map((mahasiswa) => mahasiswa.Mahasiswa_Id)
        .toSet();

    // Iterate over the new list and add students who are not in the original list to mahasiswaIdsToAdd
    for (var item in selectedMahasiswaListBaru) {
      int? mahasiswaId = item.value != null ? int.parse(item.value!) : null;
      if (mahasiswaId != null && !originalIds.contains(mahasiswaId)) {
        mahasiswaIdsToAdd.add(mahasiswaId);
      }
    }

    // Now mahasiswaIdsToAdd contains the IDs of the students to add
    print("IDs of Mahasiswa to add: $mahasiswaIdsToAdd");

    // Loop through each mahasiswa ID and add the corresponding KelasMahasiswa
    for (int mahasiswaId in mahasiswaIdsToAdd) {
      print("Debug Mahasiswa_ID Add: " + mahasiswaId.toString());
      print("Debug Kelas_ID Add: " + widget.kelas.Kelas_Id.toString());
      dynamic response = await ApiServices.setKelasMahasiswa(
          widget.kelas.Kelas_Id, mahasiswaId);
      if (response.statusCode != 201) {
        success = false;
      }
    }

    if (success) {
      return true;
    }
  }

  // Helper function to find KelasMahasiswa ID based on Mahasiswa ID (assuming a function to fetch KelasMahasiswa by Mahasiswa ID exists)
  int findKelasMahasiswaIdByMahasiswaId(int mahasiswaId, int Kelas_Id) {
    for (var i = 0; i < KelasMahasiswaList.length; i++) {
      if (KelasMahasiswaList[i].Kelas_Id == Kelas_Id &&
          KelasMahasiswaList[i].Mahasiswa_Id == mahasiswaId) {
        print("Debug Kelas Mahasiswa ID Delete: " +
            KelasMahasiswaList[i].Kelas_Mahasiswa_Id.toString());
        return KelasMahasiswaList[i].Kelas_Mahasiswa_Id;
      }
    }
    return -1;
  }

  List<ValueItem> getCombinedOptions() {
    // Use a Set to store unique ValueItems based on their value (Mahasiswa_Id)
    Set<ValueItem> uniqueOptions = {};

    // Add ValueItems from MahasiswaList to the set
    uniqueOptions.addAll(MahasiswaList.map((mahasiswa) => ValueItem(
          label: mahasiswa.Mahasiswa_Nama,
          value: mahasiswa.Mahasiswa_Id.toString(),
        )).toList());

    // Add ValueItems from selectedmahasiswaListBaru to the set (duplicates will be ignored)
    uniqueOptions.addAll(selectedmahasiswaListBaru
        .map((mahasiswa) => ValueItem(
              label: mahasiswa.Mahasiswa_Nama,
              value: mahasiswa.Mahasiswa_Id.toString(),
            ))
        .toList());

    // Convert the set back to a list
    return uniqueOptions.toList();
  }

  Widget buildMultiSelectField() {
    if (MahasiswaList.isEmpty && selectedmahasiswaListBaru.isEmpty) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show a loading indicator while data is fetched
    } else {
      return MultiSelectDropDown(
        fieldBackgroundColor: Colors.grey.shade200,
        controller: mahasiswaSelectController,
        searchEnabled: true,
        onOptionSelected: (options) {
          debugPrint(options.toString());
        },
        options: getCombinedOptions(),
        selectedOptions: selectedmahasiswaListBaru
            .map((mahasiswa) => ValueItem(
                  label: mahasiswa.Mahasiswa_Nama,
                  value: mahasiswa.Mahasiswa_Id.toString(),
                ))
            .toList(),
        selectionType: SelectionType.multi,
        // chipConfig: const ChipConfig(wrapType: WrapType.wrap),
        dropdownHeight: 200,
        dropdownMargin: 2,
        optionTextStyle: const TextStyle(fontSize: 16),
        selectedOptionIcon: const Icon(Icons.check_circle),
      );
    }
  }
}
