class MahasiswaSudahAbsen {
  final int absensiId;
  final String absensiWaktu;
  final int mahasiswaId;

  MahasiswaSudahAbsen({
    required this.absensiId,
    required this.absensiWaktu,
    required this.mahasiswaId,
  });

  factory MahasiswaSudahAbsen.fromJson(Map<String, dynamic> json) {
    return MahasiswaSudahAbsen(
      absensiId: json['Absensi_Id'],
      absensiWaktu: json['Absensi_Waktu'],
      mahasiswaId: json['Mahasiswa_Id'],
    );
  }
}
