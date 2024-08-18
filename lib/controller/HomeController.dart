part of 'Controllers.dart';

class HomeController {
  //Get Kelas
  //Function memanggil function getKelas dari APIService dan return hasil response API
  Future<List<Kelas>> getKelas() async {
    final response = await ApiServices.getKelas();
    print("DEBUG HomeController getKelas: kelasList length " +
        response.length.toString());
    return response;
  }

  //Delete Kelas
  //Function memanggil function deleteKelas berdasarkan Kelas_ID dari APIService dan return hasil response API
  Future<dynamic> deleteKelas(int kelasId) async {
    final response = await ApiServices.deleteKelas(kelasId);
    print(
        "DEBUG HomeController deleteKelas: " + response.statusCode.toString());
    return response;
  }

  //Tombol Download Excel
  Future<String?> downloadExcelButton(String url) async {
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
