part of '../Pages.dart';

class MahasiswaView extends StatefulWidget {
  const MahasiswaView({Key? key}) : super(key: key);

  @override
  _MahasiswaViewState createState() => _MahasiswaViewState();
}

class _MahasiswaViewState extends State<MahasiswaView> {
  List<Mahasiswa> mahasiswaList = [];

  //Function Get Mahasiswa
  Future<void> getMahasiswa() async {
    await ApiServices.getMahasiswa().then((value) {
      setState(() {
        mahasiswaList = value;
      });
    });
    print(mahasiswaList.toString());
  }

  //Function Delete Mahasiswa
  Future<dynamic> DeleteMahasiswa(int Mahasiswa_Id) async {
    dynamic response = true;

    // Wait for the deletion operation to complete
    await ApiServices.deleteMahasiswa(Mahasiswa_Id);

    await getMahasiswa();

    setState(() {
      mahasiswaList.removeWhere((item) => item.Mahasiswa_Id == Mahasiswa_Id);
    });

    return response;
  }

  @override
  void initState() {
    getMahasiswa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: AppBar(
        //Tombol Back
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(Icons.arrow_back_ios_rounded));
        }),
        //Judul App Bar
        title: Text(
          "Mahasiswa",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      //Body dengan drag down refresh
      body: RefreshIndicator(
        onRefresh: () => getMahasiswa(), //Function yang jalan saat Refresh
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Card List Mahasiswa
                      Flexible(
                        //Apabila List Kosong
                        child: mahasiswaList.isEmpty
                            ? Center(
                                child:
                                    CircularProgressIndicator()) //Animasi Loading Bulat
                            //Card List Builder
                            : ListView.builder(
                                key: UniqueKey(),
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                itemCount: mahasiswaList.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                    key: ValueKey(
                                        mahasiswaList[index].Mahasiswa_Id),
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            print("Debug Index: " +
                                                index.toString());
                                            print("Mahasiswa_Id" +
                                                mahasiswaList[index]
                                                    .Mahasiswa_Id
                                                    .toString());
                                            DeleteMahasiswa(
                                              mahasiswaList[index].Mahasiswa_Id,
                                            );
                                          },
                                          backgroundColor: Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: "Delete",
                                        ),
                                        SlidableAction(
                                          onPressed: (context) =>
                                              Navigator.push(
                                                  this.context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditMahasiswa(
                                                              mahasiswaList[
                                                                  index]))),
                                          backgroundColor: Color(0xFF21B7CA),
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: "Edit",
                                        ),
                                      ],
                                    ),
                                    child: LazyLoadingList(
                                      initialSizeOfItems: 10,
                                      loadMore: () {},
                                      child: MahasiswaCard(
                                        mahasiswaList[index],
                                      ),
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
            ),
          ],
        ),
      ),
      //Tombol Add Mahasiswa
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "ADD MAHASISWA",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => AddMahasiswaView()));
        }, // Implement functionality
      ),
    );
  }
}
