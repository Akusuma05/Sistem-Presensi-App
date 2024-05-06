part of '../Pages.dart';

class AbsensiView extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final int Kelas_Id;
  const AbsensiView(this.mahasiswa, this.Kelas_Id);

  @override
  _AbsensiViewState createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<AbsensiView> {
  List<dynamic> list = [];
  Future<dynamic> getAbsensi() async {
    await ApiServices.getAbsensibyId(
            widget.Kelas_Id, widget.mahasiswa.Mahasiswa_Id)
        .then((value) {
      setState(() {
        list = value;
      });
    });
    print(list.toString());
  }

  @override
  void initState() {
    getAbsensi();
    super.initState();
  }

  // Use a specific type

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
          widget.mahasiswa.Mahasiswa_Nama,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      //Body
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
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return LazyLoadingList(
                            initialSizeOfItems: 10,
                            loadMore: () {},
                            child: AbsensiCard(list[index]),
                            index: index,
                            hasMore: true,
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
                  builder: (context) => AddAbsensi(widget.Kelas_Id)));
        }, // Implement functionality
      ),
    );
  }
}
