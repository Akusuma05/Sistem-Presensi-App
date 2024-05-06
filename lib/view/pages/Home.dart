part of 'Pages.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Kelas> Kelaslist = [];
  Future<dynamic> getKelas() async {
    await ApiServices.getKelas().then((value) {
      setState(() {
        Kelaslist = value;
      });
    });
    print(Kelaslist.toString());
  }

  Future<dynamic> DeleteKelas(int Kelas_Id) async {
    dynamic response = true;
    await ApiServices.deleteKelas(Kelas_Id);
    await getKelas();
    return response;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getKelas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildUserInfo(),
                _bottomSheet(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "ADD CLASS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => AddKelas()));
        }, // Implement functionality
      ),
    );
  }

  Container _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.only(bottom: 32, top: 32, left: 16, right: 8),
      child: Row(
        children: [
          Icon(
            FeatherIcons.user,
            size: 40,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning Angelo",
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 6),
              Text(
                "070601201026",
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _bottomSheet() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(22, 16, 8, 0),
              child: Text(
                "Classes",
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Flexible(
              child: RefreshIndicator(
                onRefresh: getKelas,
                child: ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  itemCount: Kelaslist.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: ValueKey(Kelaslist[index]
                          .Kelas_Id), // Use index for unique key per item

                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        // dismissible: DismissiblePane(onDismissed: () {
                        //   DeleteKelas(Kelaslist[index].Kelas_Id);
                        // }),
                        children: [
                          SlidableAction(
                            onPressed: (context) => DeleteKelas(Kelaslist[index]
                                .Kelas_Id), // Pass context to onPressed
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          SlidableAction(
                            onPressed: (context) => Navigator.push(
                                this.context,
                                MaterialPageRoute(
                                    builder: (context) => EditKelas(Kelaslist[
                                        index]))), // Pass context to onPressed
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),

                      // The child of the Slidable is the actual list item content
                      child: LazyLoadingList(
                        initialSizeOfItems: 10,
                        loadMore: () {},
                        child: ClassCard(Kelaslist[index]),
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
    );
  }
}
