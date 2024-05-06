class KelasMahasiswa {
  int Kelas_Mahasiswa_Id;
  int Kelas_Id;
  int Mahasiswa_Id;

  KelasMahasiswa({
    required this.Kelas_Mahasiswa_Id,
    required this.Kelas_Id,
    required this.Mahasiswa_Id,
  });

  factory KelasMahasiswa.fromJson(Map<String, dynamic> json) {
    try {
      return KelasMahasiswa(
        Kelas_Mahasiswa_Id: json['Kelas_Mahasiswa_Id'] as int,
        Kelas_Id: json['Kelas_Id'] as int,
        Mahasiswa_Id: json['Mahasiswa_Id'] as int,
      );
    } on FormatException catch (e) {
      throw FormatException(
          'Failed to parse KelasMahasiswa data: ${e.message}');
    } catch (e) {
      throw FormatException(
          'Unexpected error parsing KelasMahasiswa: ${e.toString()}');
    }
  }
}
