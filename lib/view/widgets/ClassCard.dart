part of "Widgets.dart";

class ClassCard extends StatefulWidget {
  final String ClassName;
  const ClassCard(this.ClassName);

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: InkWell(
            onTap: () {},
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
                          widget.ClassName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          "Class 701",
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
