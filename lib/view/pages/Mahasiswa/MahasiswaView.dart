part of '../Pages.dart';

class MahasiswaView extends StatefulWidget {
  const MahasiswaView({Key? key}) : super(key: key);

  @override
  _MahasiswaViewState createState() => _MahasiswaViewState();
}

class _MahasiswaViewState extends State<MahasiswaView> {
  MahasiswaController mahasiswaController = MahasiswaController();
  List<Mahasiswa> mahasiswaList = [];
  List<Mahasiswa> searchMahasiswaList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getMahasiswa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildMahasiswaListView(),
      floatingActionButton: _buildAddMahasiswaButton(),
    );
  }

  //Build UI AppBar
  AppBar _buildAppBar() {
    return AppBar(
      //Judul App Bar
      title: Text(
        "Mahasiswa",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  //Build UI Mahasiswa ListView
  RefreshIndicator _buildMahasiswaListView() {
    return RefreshIndicator(
      onRefresh: () => getMahasiswa(),
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Search Bar
                    _buildSearchBar(),
                    //Card List Mahasiswa
                    _buildMahasiswaCardListView(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Build UI SearchBar
  Padding _buildSearchBar() {
    return Padding(
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
                  borderRadius: BorderRadius.all(Radius.circular(24.0)))),
          onChanged: (value) {
            filterSearchResults(value);
          },
        ),
      ),
    );
  }

  //Build UI Mahasiswa Card View List View
  Flexible _buildMahasiswaCardListView() {
    return Flexible(
      //Apabila List Kosong
      child: searchMahasiswaList.isEmpty && mahasiswaList.isEmpty
          ? Center(child: CircularProgressIndicator()) //Animasi Loading Bulat
          //Card List Builder
          : ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              itemCount: searchMahasiswaList.length,
              itemBuilder: (context, index) {
                //Slidable Tombol Edit dan Delete
                return Slidable(
                  key: ValueKey(searchMahasiswaList[index].Mahasiswa_Id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      //Tombol Delete
                      SlidableAction(
                        onPressed: (context) => DeleteMahasiswa(
                          searchMahasiswaList[index].Mahasiswa_Id,
                        ),
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                      ),
                      //Tombol Edit
                      SlidableAction(
                        onPressed: (context) => Navigator.push(
                            this.context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditMahasiswa(searchMahasiswaList[index]))),
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                      ),
                    ],
                  ),
                  //Card View Mahasiswa
                  child: LazyLoadingList(
                    initialSizeOfItems: 10,
                    loadMore: () {},
                    child: MahasiswaCard(
                      searchMahasiswaList[index],
                    ),
                    index: index,
                    hasMore: true,
                  ),
                );
              },
            ),
    );
  }

  //Build UI Add Mahasiswa Button
  FloatingActionButton _buildAddMahasiswaButton() {
    return FloatingActionButton.extended(
      label: const Text(
        "ADD MAHASISWA",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      onPressed: () {
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => AddMahasiswaView()));
      },
    );
  }

  //Function Get Mahasiswa
  Future<void> getMahasiswa() async {
    final response = await mahasiswaController.getMahasiswa();
    setState(() {
      mahasiswaList = response;
      searchMahasiswaList = response;
    });
    print("DEBUG MahasiswaView getMahasiswa: mahasiswaList length " +
        response.length.toString());
  }

  //Function Delete Mahasiswa
  Future<dynamic> DeleteMahasiswa(int mahasiswaId) async {
    final response = await mahasiswaController.deleteMahasiswa(mahasiswaId);
    await getMahasiswa();
    print("DEBUG MahasiswaView deleteMahasiswa: " +
        response.statusCode.toString());
  }

  //Filter Search Result
  //Function mengisi searchMahasiswaList berdasarkan hasil filter mahasiswaList
  void filterSearchResults(String query) {
    setState(() {
      searchMahasiswaList = mahasiswaList
          .where((Mahasiswa) => Mahasiswa.Mahasiswa_Nama.toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }
}
