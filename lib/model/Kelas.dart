class Kelas {
  final int Kelas_Id;
  final String Kelas_Nama;
  final String Kelas_Lokasi;
  final String Kelas_Id_varchar;
  final String Jam_Mulai;
  final String Jam_Selesai;

  Kelas({
    required this.Kelas_Id,
    required this.Kelas_Nama,
    required this.Kelas_Lokasi,
    required this.Kelas_Id_varchar,
    required this.Jam_Mulai,
    required this.Jam_Selesai,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    try {
      return Kelas(
        Kelas_Id: json['Kelas_Id'] as int,
        Kelas_Id_varchar: json['Kelas_Id_varchar'] as String,
        Kelas_Nama: json['Kelas_Nama'] as String,
        Kelas_Lokasi: json['Kelas_Lokasi'] as String,
        Jam_Mulai: json['Jam_Mulai'] as String,
        Jam_Selesai: json['Jam_Selesai'] as String,
      );
    } on FormatException catch (e) {
      throw FormatException('Failed to parse Kelas data: ${e.message}');
    } catch (e) {
      throw FormatException('Unexpected error parsing Kelas: ${e.toString()}');
    }
  }
}
