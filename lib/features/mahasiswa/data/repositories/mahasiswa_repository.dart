import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';

class MahasiswaRepository {
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 1));

    return [
      MahasiswaModel(
        nim: '434241100',
        nama: 'Ody Dzakwan Berwin',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2024',
        ipk: 3.85,
        isAktif: true,
      ),
      MahasiswaModel(
        nim: '434241079',
        nama: 'Irfan Nuha',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2024',
        ipk: 3.40,
        isAktif: true,
      ),
      MahasiswaModel(
        nim: '434241012',
        nama: 'M. Surya Prakoso',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2020',
        ipk: 3.92,
        isAktif: true,
      ),
      MahasiswaModel(
        nim: '434241099',
        nama: 'M. Fadhil Ilyas',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2024',
        ipk: 2.80,
        isAktif: false,
      ),
      MahasiswaModel(
        nim: '434241055',
        nama: 'Nabil Hakim',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2024',
        ipk: 3.75,
        isAktif: true,
      ),
      MahasiswaModel(
        nim: '434251122',
        nama: 'Kafka Nafisa Maulidiyah',
        jurusan: 'D4 Teknik Informatika',
        angkatan: '2025',
        ipk: 3.10,
        isAktif: true,
      ),
    ];
  }
}
