class Mahasiswa {
  int Mahasiswa_Id;
  String Mahasiswa_Nama;
  String Mahasiswa_Foto;

  Mahasiswa({
    required this.Mahasiswa_Id,
    required this.Mahasiswa_Nama,
    required this.Mahasiswa_Foto,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    try {
      return Mahasiswa(
        Mahasiswa_Id: json['Mahasiswa_Id'] as int,
        Mahasiswa_Nama: json['Mahasiswa_Nama'] as String,
        Mahasiswa_Foto: json['Mahasiswa_Foto'] as String,
      );
    } on FormatException catch (e) {
      throw FormatException('Failed to parse Mahasiswa data: ${e.message}');
    } catch (e) {
      throw FormatException(
          'Unexpected error parsing Mahasiswa: ${e.toString()}');
    }
  }
}
