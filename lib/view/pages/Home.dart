part of 'Pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Icon(FeatherIcons.user),
                ),
                Column(
                  children: [
                    Container(
                      // width: double.infinity,
                      child: const Text(
                        "Good Morning Angelo",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      // width: double.infinity,
                      child: const Text(
                        "070601201026",
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
