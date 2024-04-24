part of '../Pages.dart';

class EditAbsensi extends StatefulWidget {
  const EditAbsensi({Key? key}) : super(key: key);

  @override
  _EditAbsensiState createState() => _EditAbsensiState();
}

class _EditAbsensiState extends State<EditAbsensi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(Icons.arrow_back_ios_rounded));
        }),
        title: Text(
          "Edit Absensi",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
