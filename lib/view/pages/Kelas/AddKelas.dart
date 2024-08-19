part of '../Pages.dart';

class AddKelas extends StatefulWidget {
  const AddKelas({Key? key}) : super(key: key);

  @override
  _AddKelasState createState() => _AddKelasState();
}

class _AddKelasState extends State<AddKelas> {
  final ctrlName = TextEditingController();
  final ctrlLocation = TextEditingController();
  final ctrlKelasIdVarchar = TextEditingController();
  final MultiSelectController ctrlMahasiswa = MultiSelectController();
  List<Mahasiswa> MahasiswaList = [];
  List<ValueItem> SelectedMahasiswaList = [];
  List<Kelas> KelasBaru = [];

  @override
  void dispose() {
    ctrlName.dispose();
    ctrlLocation.dispose();
    ctrlKelasIdVarchar.dispose();
    SelectedMahasiswaList = [];
    super.dispose();
  }

  @override
  void initState() {
    GetMahasiswa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //AppBar
        appBar: _buildAppBar(),

        //Body
        body: _buildBottomSheet());
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      //Tombol Back
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(Icons.arrow_back_ios_rounded));
      }),

      //Judul AppBar
      title: Text(
        "Add Kelas",
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
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Form Data Kelas
                Form(
                  child: Column(children: [
                    //Text Field Class Name
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Kelas Id",
                      ),
                      controller: ctrlKelasIdVarchar,
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

                    FieldSelectMahasiswa(),

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

                    //Tombol Add
                    ElevatedButton(
                      onPressed: () {
                        if (ctrlName.text.toString() == "" ||
                            ctrlLocation.text.toString() == "" ||
                            ctrlKelasIdVarchar.text.toString() == "") {
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
                          if (InputKelas() != null) {
                            Fluttertoast.showToast(
                                msg: "Kelas Berhasil Ditambahkan",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 14);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Penambahan Kelas Gagal",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 14);
                          }
                        }
                      },
                      child: const Text(
                        'ADD KELAS',
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
      ),
    );
  }

  //Build UI Select Mahasiswa
  Widget FieldSelectMahasiswa() {
    if (MahasiswaList.isEmpty) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show a loading indicator while data is fetched
    } else {
      return MultiSelectDropDown(
        controller: ctrlMahasiswa,
        searchEnabled: true,
        onOptionSelected: (options) {
          debugPrint(options.toString());
        },
        options: MahasiswaList.map((mahasiswa) => ValueItem(
              label: mahasiswa.Mahasiswa_Nama,
              value: mahasiswa.Mahasiswa_Id.toString(),
            )).toList(),
        selectionType: SelectionType.multi,
        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
        dropdownHeight: 200,
        optionTextStyle: const TextStyle(fontSize: 16),
        selectedOptionIcon: const Icon(Icons.check_circle),
      );
    }
  }

  //Function Input Kelas
  Future<dynamic> InputKelas() async {
    dynamic response = true;
    await ApiServices.setKelas(ctrlName.text.toString(),
            ctrlLocation.text.toString(), ctrlKelasIdVarchar.text.toString())
        .then((value) async {
      // mark this function as async
      SelectedMahasiswaList = ctrlMahasiswa.selectedOptions;
      for (var i = 0; i < SelectedMahasiswaList.length; i++) {
        await ApiServices.setKelasMahasiswa(
            value[0].Kelas_Id, int.parse(SelectedMahasiswaList[i].value!));
      }
      var key = GlobalKey<_HomeState>();
      Navigator.pushReplacement(this.context,
          MaterialPageRoute(builder: (context) => Homepage(key: key)));
    });
    return response;
  }

  //Function Get Mahasiswa
  Future<void> GetMahasiswa() async {
    await ApiServices.getMahasiswa().then((value) {
      setState(() {
        MahasiswaList = value;
      });
    });
  }
}
