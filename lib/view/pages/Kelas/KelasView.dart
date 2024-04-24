part of '../Pages.dart';

class KelasView extends StatefulWidget {
  final String ClassName;
  const KelasView(this.ClassName);

  @override
  _KelasViewState createState() => _KelasViewState();
}

class _KelasViewState extends State<KelasView> {
  final List<String> StudentList = ["Angelo", "Yay"];

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
            widget.ClassName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          itemCount: StudentList.length,
                          itemBuilder: (context, index) {
                            return LazyLoadingList(
                              initialSizeOfItems: 10,
                              loadMore: () {},
                              child: StudentCard(StudentList[index]),
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
        ));
  }
}
