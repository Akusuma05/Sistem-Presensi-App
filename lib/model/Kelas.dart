class Kelas {
  final int Kelas_Id;
  final String Kelas_Nama;
  final String Kelas_Lokasi;

  Kelas({
    required this.Kelas_Id,
    required this.Kelas_Nama,
    required this.Kelas_Lokasi,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    try {
      return Kelas(
        Kelas_Id: json['Kelas_Id'] as int,
        Kelas_Nama: json['Kelas_Nama'] as String,
        Kelas_Lokasi: json['Kelas_Lokasi'] as String,
      );
    } on FormatException catch (e) {
      throw FormatException('Failed to parse Kelas data: ${e.message}');
    } catch (e) {
      throw FormatException('Unexpected error parsing Kelas: ${e.toString()}');
    }
  }
}
