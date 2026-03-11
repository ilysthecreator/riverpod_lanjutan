import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';

// AsyncNotifier Provider untuk state mahasiswa aktif
class MahasiswaAktifNotifier extends AsyncNotifier<List<MahasiswaModel>> {
  @override
  Future<List<MahasiswaModel>> build() async {
    return _fetchMahasiswaAktif();
  }

  Future<List<MahasiswaModel>> _fetchMahasiswaAktif() async {
    final repository = ref.read(mahasiswaRepositoryProvider);
    final allMahasiswa = await repository.getMahasiswaList();
    return allMahasiswa.where((mhs) => mhs.isAktif).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMahasiswaAktif());
  }
}

final mahasiswaAktifNotifierProvider =
    AsyncNotifierProvider<MahasiswaAktifNotifier, List<MahasiswaModel>>(() {
  return MahasiswaAktifNotifier();
});
