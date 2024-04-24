part of "Widgets.dart";

class StudentCard extends StatefulWidget {
  final String NamaMurid;
  const StudentCard(this.NamaMurid);

  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
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
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) => AbsensiView(widget.NamaMurid)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.NamaMurid,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))
            ],
          ),
        ),
      ),
    );
  }
}
