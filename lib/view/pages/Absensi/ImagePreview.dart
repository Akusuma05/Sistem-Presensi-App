part of '../Pages.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview(this.file, {super.key});
  XFile file;
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Preview"),
      ),
      body: Center(
        child: Image.file(picture),
      ),
    );
  }
}
