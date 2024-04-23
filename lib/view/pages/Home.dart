part of 'Pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [_buildUserInfo(), _bottomSheet()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Padding _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 32, top: 16, left: 8, right: 8), // Add this line
      child: Row(
        children: [
          Icon(
            FeatherIcons.user,
            size: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning Angelo",
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 6),
              Text(
                "070601201026",
                textAlign: TextAlign.left,
              )
            ],
          )
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0), // Add this line
              child: Text(
                "Classes",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  NavigationBar _buildBottomNavigationBar() {
    return NavigationBar(
      height: 80,
      elevation: 0,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile")
      ],
    );
  }
}
