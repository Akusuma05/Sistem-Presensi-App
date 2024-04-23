part of 'Pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<String> classList = ["Math", "Physics"]; // Use a specific type

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
        onPressed: () {}, // Implement functionality
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  return LazyLoadingList(
                    initialSizeOfItems: 10,
                    loadMore: () {},
                    child: ClassCard(classList[index]),
                    index: index,
                    hasMore: true,
                  );
                },
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
        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
