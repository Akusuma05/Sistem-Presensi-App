part of 'Pages.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeController = HomeController();
  TextEditingController searchController = TextEditingController();

  List<Kelas> kelasList = [];
  List<Kelas> searchKelasList = [];

  final now = DateTime.now();
  String greeting = "";
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildBottomSheet(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildAddClassButton());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getKelas();
    customText();
    super.initState();
  }

  void customText() {
    if (now.hour >= 5 && now.hour < 12) {
      greeting = "Selamat Pagi";
      message = "Semoga Harimu Berjalan dengan Lancar!";
    } else if (now.hour >= 12 && now.hour < 17) {
      greeting = "Selamat Siang";
      message = "Semoga pekerjaanmu lancar hari ini.";
    } else {
      greeting = "Selamat Malam";
      message = "Selamat beristirahat!";
    }
  }

  //Build UI Header
  Container _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 32, top: 32, left: 16, right: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text Selamat Pagi
              Text(
                greeting,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              //Text Semoga Harimu Berjalan Lancar
              Text(
                message,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const Spacer(),
          //Tombol Download
          IconButton(
            onPressed: () async {
              String url = 'http://' + Const.baseUrl + '/api/Absensi/Export';
              await homeController.downloadExcelButton(url);
            },
            icon: Icon(
              Icons.download,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  //Build UI Bottom Sheet
  Expanded _buildBottomSheet() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
          //Box Rounded Corner
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          width: double.infinity,

          //Isi dari Bottom Sheet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 8, 0),
                //Tulisan Classes
                child: Text(
                  "Classes",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              //Search Bar
              _buildSearchBar(),
              //Kelas Card View
              _buildListViewKelasCardView(),
            ],
          ),
        ),
      ),
    );
  }

  //Build UI Add Kelas Button
  FloatingActionButton _buildAddClassButton() {
    return FloatingActionButton.extended(
      label: const Text(
        "ADD KELAS",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xffACC196),
      onPressed: () {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => AddKelas()));
      },
    );
  }

  //Build UI Search Bar
  Padding _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
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
                  borderRadius: BorderRadius.all(Radius.circular(20.0)))),
          onChanged: (value) {
            _filterSearchResults(value);
          },
        ),
      ),
    );
  }

  //Build UI Kelas Card View
  Flexible _buildListViewKelasCardView() {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: getKelas,
        child: searchKelasList.isEmpty && kelasList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                key: UniqueKey(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                itemCount: searchKelasList.length,
                itemBuilder: (context, index) {
                  //Slidable Tombol Edit dan Delete
                  return Slidable(
                    key: ValueKey(searchKelasList[index].Kelas_Id),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        //Tombol Delete
                        SlidableAction(
                          onPressed: (context) =>
                              DeleteKelas(searchKelasList[index].Kelas_Id),
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        //Tombol Edit
                        SlidableAction(
                          onPressed: (context) => Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => EditKelas(
                                      searchKelasList[
                                          index]))), // Pass context to onPressed
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    //Card View Kelas
                    child: LazyLoadingList(
                      initialSizeOfItems: 10,
                      loadMore: () {},
                      child: ClassCard(searchKelasList[index]),
                      index: index,
                      hasMore: true,
                    ),
                  );
                },
              ),
      ),
    );
  }

  //Get Kelas
  //Function untuk memanggil hasil response dari HomeController dari mengisi variable KelasList dan SearchKelasList
  Future<dynamic> getKelas() async {
    final response = await homeController.getKelas();
    setState(() {
      kelasList = response;
      searchKelasList = response;
    });
    print("DEBUG HomeView getKelas: kelasList length " +
        response.length.toString());
  }

  //Delete Kelas
  //Function untuk memanggil hasil response dari HomeController untuk menghapus Kelas berdasarkan KelasId yang diinput
  Future<dynamic> DeleteKelas(int Kelas_Id) async {
    dynamic response = await homeController.deleteKelas(Kelas_Id);
    await getKelas();
    print("DEBUG HomeView deleteKelas: " + response.statusCode.toString());
    return response;
  }

  //Filter Search Result
  //Function mengisi SearchKelasList berdasarkan hasil filter KelasList
  void _filterSearchResults(String query) {
    setState(() {
      searchKelasList = kelasList
          .where((Kelas) =>
              Kelas.Kelas_Nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
