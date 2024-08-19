part of '../Pages.dart';

class KelasView extends StatefulWidget {
  final Kelas kelas;
  const KelasView(this.kelas);

  @override
  _KelasViewState createState() => _KelasViewState();
}

class _KelasViewState extends State<KelasView> {
  List<Mahasiswa> mahasiswaList = [];
  List<KelasMahasiswa> kelasMahasiswaList = [];
  List<MahasiswaSudahAbsen> mahasiswaSudahAbsenList = [];
  List<Mahasiswa> searchMahasiswaList = [];

  TextEditingController searchController = TextEditingController();

  bool _isLoadingMahasiswa = false;
  bool _isLoadingKelasMahasiswa = false;
  bool _isLoadingMahasiswaSudahAbsen = false;

  @override
  void initState() {
    getMahasiswaSudahAbsen(widget.kelas.Kelas_Id);
    getKelasMahasiswaByKelasId(widget.kelas.Kelas_Id);
    getMahasiswaByKelasId(widget.kelas.Kelas_Id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: _buildAppBar(),

      //Body
      body: _buildBottomSheet(),

      //Floating Action Button
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(Icons.arrow_back_ios_rounded));
      }),
      title: Column(
        children: [
          Text(
            widget.kelas.Kelas_Nama,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.kelas.Kelas_Id_varchar,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Search Bar
              Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)))),
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                  ),
                ),
              ),
              Flexible(
                child: _isLoadingMahasiswa &&
                        _isLoadingMahasiswaSudahAbsen &&
                        _isLoadingKelasMahasiswa
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        // Only show RefreshIndicator when data is loaded
                        onRefresh: () async {
                          await getMahasiswaSudahAbsen(widget.kelas.Kelas_Id);
                          await getMahasiswaByKelasId(widget.kelas.Kelas_Id);
                        },
                        child: ListView.builder(
                          key: UniqueKey(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          itemCount: searchMahasiswaList.length,
                          itemBuilder: (context, index) {
                            return LazyLoadingList(
                              initialSizeOfItems: 10,
                              loadMore: () {},
                              child: StudentCard(
                                  searchMahasiswaList[index],
                                  widget.kelas.Kelas_Id,
                                  mahasiswaSudahAbsenList.any(
                                      (MahasiswaSudahAbsen) =>
                                          MahasiswaSudahAbsen.mahasiswaId ==
                                          mahasiswaList[index].Mahasiswa_Id)),
                              index: index,
                              hasMore: true,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Build UI Floating Action Button
  FloatingActionButton _buildFloatingActionButton() {
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
                builder: (context) => AddAbsensi(widget.kelas.Kelas_Id)));
      }, // Implement functionality
    );
  }

  Future<void> getMahasiswaByKelasId(int Kelas_Id) async {
    setState(() {
      _isLoadingMahasiswa = true; // Set loading flag to true
    });
    await ApiServices.getMahasiswaByKelasId(Kelas_Id).then((value) {
      setState(() {
        mahasiswaList = value;
        searchMahasiswaList = value;
        _isLoadingMahasiswa =
            false; // Set loading flag to false after data is fetched
      });
    });
  }

  //Function Get Absensi Mahasiswa Yang Sudah Absen Dalam waktu satu jam
  Future<void> getMahasiswaSudahAbsen(int Kelas_Id) async {
    setState(() {
      _isLoadingMahasiswaSudahAbsen = true;
    });
    await ApiServices.getMahasiswaSudahAbsen(Kelas_Id).then((value) {
      mahasiswaSudahAbsenList = value;
      _isLoadingMahasiswaSudahAbsen = false;
    });
  }

  Future<void> getKelasMahasiswaByKelasId(int Kelas_Id) async {
    setState(() {
      _isLoadingKelasMahasiswa = true;
    });
    await ApiServices.getKelasMahasiswabyId(Kelas_Id).then((value) {
      setState(() {
        kelasMahasiswaList = value;
        _isLoadingKelasMahasiswa = false;
      });
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      searchMahasiswaList = mahasiswaList
          .where((Mahasiswa) => Mahasiswa.Mahasiswa_Nama.toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }
}
