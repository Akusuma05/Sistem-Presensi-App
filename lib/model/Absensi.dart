class Absensi {
  final int Absensi_Id;
  final int Kelas_Mahasiswa_Id;
  final DateTime Absensi_Waktu;

  const Absensi({
    required this.Absensi_Id,
    required this.Kelas_Mahasiswa_Id,
    required this.Absensi_Waktu,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    try {
      return Absensi(
        Absensi_Id: json['Absensi_Id'] as int,
        Kelas_Mahasiswa_Id: json['Kelas_Mahasiswa_Id'] as int,
        Absensi_Waktu: DateTime.parse(json['Absensi_Waktu']),
      );
    } on FormatException catch (e) {
      throw FormatException('Failed to parse Absensi data: ${e.message}');
    } catch (e) {
      throw FormatException(
          'Unexpected error parsing Absensi: ${e.toString()}');
    }
  }
}
