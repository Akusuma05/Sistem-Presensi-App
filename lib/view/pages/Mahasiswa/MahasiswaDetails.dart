part of '../Pages.dart';

class MahasiswaDetails extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const MahasiswaDetails(this.mahasiswa);

  @override
  _MahasiswaDetailsState createState() => _MahasiswaDetailsState();
}

class _MahasiswaDetailsState extends State<MahasiswaDetails> {
  @override
  void initState() {
    clearImageCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBottomSheet(),
    );
  }

  //Build UI App Bar
  AppBar _buildAppBar() {
    return AppBar(
      //Tombol Back
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(Icons.arrow_back_ios_rounded));
      }),
      //Judul App Bar
      title: Text(
        widget.mahasiswa.Mahasiswa_Nama,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  //Build UI Bottom Sheet
  Expanded _buildBottomSheet() {
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
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Gambar Mahasiswa
              Image(
                key: UniqueKey(),
                image: NetworkImage(
                  'http://' +
                      Const.baseUrl +
                      '/api/images/' +
                      widget.mahasiswa.Mahasiswa_Foto,
                ),
                loadingBuilder: (context, imageProvider, loadingProgress) {
                  if (loadingProgress == null) return imageProvider;
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Function untuk Clear Cache Image
void clearImageCache() {
  imageCache.clear();
  imageCache.clearLiveImages();
}
