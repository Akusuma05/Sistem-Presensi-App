part of 'Controllers.dart';

class HomeController {
  //Tombol Download Excel
  Future<String?> DownloadExcelButton(String url) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String saveDir = appDir.path;

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: saveDir,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );

    await OpenFile.open(saveDir);

    return taskId;
  }
}
