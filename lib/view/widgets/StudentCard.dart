part of "Widgets.dart";

class StudentCard extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final int Kelas_id;
  final bool isAbsen;
  const StudentCard(this.mahasiswa, this.Kelas_id, this.isAbsen);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: widget.isAbsen ? Colors.green[400] : Colors.red[400],
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) =>
                        AbsensiView(widget.mahasiswa, widget.Kelas_id)));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.mahasiswa.Mahasiswa_Nama,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Enable text wrapping with ellipsis (...)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
