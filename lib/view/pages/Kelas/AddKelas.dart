part of '../Pages.dart';

class AddKelas extends StatefulWidget {
  const AddKelas({Key? key}) : super(key: key);

  @override
  _AddKelasState createState() => _AddKelasState();
}

class _AddKelasState extends State<AddKelas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 40,
              ),
              Text("Add Kelas")
            ],
          )
        ],
      ),
    ));
  }
}
