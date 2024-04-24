part of "Widgets.dart";

class AbsensiCard extends StatefulWidget {
  final String date;
  final String time;
  const AbsensiCard(this.date, this.time);

  @override
  _AbsensiCardState createState() => _AbsensiCardState();
}

class _AbsensiCardState extends State<AbsensiCard> {
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
                  MaterialPageRoute(builder: (context) => EditAbsensi()));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
