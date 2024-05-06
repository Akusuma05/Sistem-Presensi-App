part of '../Pages.dart';

class KelasView extends StatefulWidget {
  final Kelas kelas;
  const KelasView(this.kelas);

  @override
  _KelasViewState createState() => _KelasViewState();
}

class _KelasViewState extends State<KelasView> {
  List<Mahasiswa> mahasiswaList = [];
  List<KelasMahasiswa> KelasMahasiswaList = [];

  Future<void> getMahasiswaByKelasId(int Kelas_Id) async {
    await ApiServices.getMahasiswaByKelasId(Kelas_Id).then((value) {
      setState(() {
        mahasiswaList = value;
      });
    });
    print(mahasiswaList.toString());
  }

  Future<void> getKelasMahasiswaByKelasId(int Kelas_Id) async {
    await ApiServices.getKelasMahasiswabyId(Kelas_Id).then((value) {
      setState(() {
        KelasMahasiswaList = value;
      });
    });
    print(KelasMahasiswaList.toString());
  }

  Future<dynamic> DeleteKelasMahasiswa(
      int KelasMahasiswa_Id, int Kelas_Id, int Mahasiswa_id) async {
    dynamic response = true;

    // Wait for the deletion operation to complete
    await ApiServices.deleteKelasMahasiswa(KelasMahasiswa_Id);

    // Then update the lists
    await getMahasiswaByKelasId(Kelas_Id);
    await getKelasMahasiswaByKelasId(Kelas_Id);

    setState(() {
      KelasMahasiswaList.removeWhere(
          (item) => item.Kelas_Mahasiswa_Id == KelasMahasiswa_Id);
      mahasiswaList.removeWhere((item) => item.Mahasiswa_Id == Mahasiswa_id);
    });

    return response;
  }

  @override
  void initState() {
    getKelasMahasiswaByKelasId(widget.kelas.Kelas_Id);
    getMahasiswaByKelasId(widget.kelas.Kelas_Id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(Icons.arrow_back_ios_rounded));
        }),
        title: Text(
          widget.kelas.Kelas_Nama,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditKelas(widget.kelas)),
                );
              },
            );
          }),
        ],
        centerTitle: true,
      ),

      //Bottom Sheet
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
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            getMahasiswaByKelasId(widget.kelas.Kelas_Id),
                        child: ListView.builder(
                          key: UniqueKey(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          itemCount: mahasiswaList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              key: ValueKey(mahasiswaList[index].Mahasiswa_Id),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      print("Debug Index: " + index.toString());
                                      print("Debug KM_Id: " +
                                          KelasMahasiswaList[index]
                                              .Kelas_Mahasiswa_Id
                                              .toString());
                                      print("Mahasiswa_Id" +
                                          KelasMahasiswaList[index]
                                              .Mahasiswa_Id
                                              .toString());
                                      DeleteKelasMahasiswa(
                                          KelasMahasiswaList[index]
                                              .Kelas_Mahasiswa_Id,
                                          widget.kelas.Kelas_Id,
                                          KelasMahasiswaList[index]
                                              .Mahasiswa_Id);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: "Delete",
                                  ),
                                ],
                              ),
                              child: LazyLoadingList(
                                initialSizeOfItems: 10,
                                loadMore: () {},
                                child: StudentCard(mahasiswaList[index],
                                    widget.kelas.Kelas_Id),
                                index: index,
                                hasMore: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "ADD ABSENSI",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              this.context,
              MaterialPageRoute(
                  builder: (context) => AddAbsensi(widget.kelas.Kelas_Id)));
        }, // Implement functionality
      ),
    );
  }
}
