part of '../Pages.dart';

class AbsensiView extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final int Kelas_Id;
  const AbsensiView(this.mahasiswa, this.Kelas_Id);

  @override
  _AbsensiViewState createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<AbsensiView> {
  AbsensiController absensiController = AbsensiController();
  List<Absensi> AbsensiList = [];
  bool LoadingAbsensi = false; //Loading Animasi Lingkaran

  @override
  void initState() {
    getAbsensi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: _buildAppBar(),
      //Bottom Sheet
      body: _buildBottomSheet(),
      //Tombol Add Absensi
      floatingActionButton: _buildFloatingButton(),
    );
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      //Tombol Back App Bar
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(Icons.arrow_back_ios_rounded));
      }),
      //Judul App Bar
      title: Text(
        widget.mahasiswa.Mahasiswa_Nama,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  //Build UI Bottom Sheet
  RefreshIndicator _buildBottomSheet() {
    return RefreshIndicator(
      onRefresh: getAbsensi,
      child: Column(
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

                //Card List Absensi
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: LoadingAbsensi
                          ? Center(
                              child:
                                  CircularProgressIndicator()) //Animasi Loading
                          //Card List Builder Absensi
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              itemCount: AbsensiList.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: ValueKey(AbsensiList[index].Absensi_Id),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      //Tombol Delete
                                      SlidableAction(
                                        onPressed: (context) => deleteAbsensi(
                                            AbsensiList[index].Absensi_Id),
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: LazyLoadingList(
                                    initialSizeOfItems: 10,
                                    loadMore: () {},
                                    child: AbsensiCard(AbsensiList[index]),
                                    index: index,
                                    hasMore: true,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Build UI Floating Button
  FloatingActionButton _buildFloatingButton() {
    return FloatingActionButton.extended(
      label: const Text(
        "ADD ABSENSI",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => AddAbsensi(widget.Kelas_Id)));
      }, // Implement functionality
    );
  }

  //Function Get Absensi
  Future<dynamic> getAbsensi() async {
    setState(() {
      LoadingAbsensi = true; // Set loading flag to true
    });
    await ApiServices.getAbsensibyId(
            widget.Kelas_Id, widget.mahasiswa.Mahasiswa_Id)
        .then((value) {
      setState(() {
        AbsensiList = value;
        LoadingAbsensi =
            false; // Set loading flag to false after data is fetched
      });
    });
  }

  //Function untuk memanggil hasil response dari HomeController untuk menghapus Kelas berdasarkan KelasId yang diinput
  Future<dynamic> deleteAbsensi(int absensiId) async {
    dynamic response = await absensiController.deleteAbsensi(absensiId);
    await getAbsensi();
    print("DEBUG AbsensiView deleteAbsensi: " + response.statusCode.toString());
    return response;
  }
}
