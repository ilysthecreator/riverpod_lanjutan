import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/repositories/mahasiswa_repository.dart';

// Provider untuk Repository
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

// AsyncNotifier Provider untuk state mahasiswa
class MahasiswaNotifier extends AsyncNotifier<List<MahasiswaModel>> {
  @override
  Future<List<MahasiswaModel>> build() async {
    return _fetchMahasiswa();
  }

  Future<List<MahasiswaModel>> _fetchMahasiswa() async {
    final repository = ref.read(mahasiswaRepositoryProvider);
    return await repository.getMahasiswaList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMahasiswa());
  }
}

final mahasiswaNotifierProvider =
    AsyncNotifierProvider<MahasiswaNotifier, List<MahasiswaModel>>(() {
  return MahasiswaNotifier();
});
