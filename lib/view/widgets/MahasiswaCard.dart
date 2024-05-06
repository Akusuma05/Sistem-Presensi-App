part of "Widgets.dart";

class MahasiswaCard extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const MahasiswaCard(this.mahasiswa);

  @override
  _MahasiswaCardState createState() => _MahasiswaCardState();
}

class _MahasiswaCardState extends State<MahasiswaCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => MahasiswaDetails()));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.mahasiswa.Mahasiswa_Nama,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
