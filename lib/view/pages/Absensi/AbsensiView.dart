part of '../Pages.dart';

class AbsensiView extends StatefulWidget {
  final String StudentName;
  const AbsensiView(this.StudentName);

  @override
  _AbsensiViewState createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<AbsensiView> {
  final List<String> DateList = ["11/12/23", "12/12/23"];
  final List<String> TimeList = ["00.00", "12.00"]; // Use a specific type

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
          widget.StudentName,
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
                        itemCount: DateList.length,
                        itemBuilder: (context, index) {
                          return LazyLoadingList(
                            initialSizeOfItems: 10,
                            loadMore: () {},
                            child:
                                AbsensiCard(DateList[index], TimeList[index]),
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
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => AddAbsensi()));
        }, // Implement functionality
      ),
    );
  }
}
