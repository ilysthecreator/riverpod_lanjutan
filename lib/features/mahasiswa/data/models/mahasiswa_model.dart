  class MahasiswaModel {
  final String nim;
  final String nama;
  final String jurusan;
  final String angkatan;
  final double ipk;
  final bool isAktif;

  MahasiswaModel({
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.angkatan,
    required this.ipk,
    this.isAktif = true,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      jurusan: json['jurusan'] ?? '',
      angkatan: json['angkatan'] ?? '',
      ipk: (json['ipk'] ?? 0.0).toDouble(),
      isAktif: json['is_aktif'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'angkatan': angkatan,
      'ipk': ipk,
      'is_aktif': isAktif,
    };
  }
}
