part of '../Pages.dart';

class AddKelas extends StatefulWidget {
  const AddKelas({Key? key}) : super(key: key);

  @override
  _AddKelasState createState() => _AddKelasState();
}

class _AddKelasState extends State<AddKelas> {
  final ctrlName = TextEditingController();
  final ctrlLocation = TextEditingController();

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
            "Add Kelas",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        //Body
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
                      Form(
                        child: Column(children: [
                          //Text Field Class Name
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Class Name",
                            ),
                            controller: ctrlName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.toString().isEmpty
                                  ? 'Please fill in the blank!'
                                  : null;
                            },
                          ),

                          SizedBox(
                            height: 16,
                          ),

                          //Text Field Class Location
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Class Location",
                            ),
                            controller: ctrlLocation,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.toString().isEmpty
                                  ? 'Please fill in the blank!'
                                  : null;
                            },
                          ),

                          SizedBox(
                            height: 32,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (ctrlName.text.toString() == "" ||
                                  ctrlLocation.text.toString() == "") {
                                showDialog(
                                    context: context,
                                    builder: ((((context) {
                                      return AlertDialog(
                                        title: Text("There is an Error!"),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Please fill in the blanks!"),
                                            ]),
                                      );
                                    }))));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'ADD KELAS',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                          )
                        ]),
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
