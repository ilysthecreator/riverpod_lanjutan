import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/core/services/local_storage_service.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/repositories/mahasiswa_repository.dart';

final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
}); 

final mahasiswaLocalStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final savedMahasiswaProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(mahasiswaLocalStorageServiceProvider);
  return storage.getSavedMahasiswa();
});

class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  final LocalStorageService _storage;

  MahasiswaNotifier(this._repository, this._storage) : super(const AsyncValue.loading()) {
    loadMahasiswaList();
  }

  Future<void> loadMahasiswaList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMahasiswaList();
  }

  // Simpan mahasiswa yang dipilih ke local storage
  Future<void> saveSelectedMahasiswa(MahasiswaModel mahasiswa) async {
    await _storage.addMahasiswaToSavedList(
      id: mahasiswa.id.toString(),
      name: mahasiswa.name,
    );
  }

  // Hapus mahasiswa tertentu dari list
  Future<void> removeSelectedMahasiswa(String id) async {
    await _storage.removeSavedMahasiswa(id);
  }

  // Hapus semua mahasiswa dari list
  Future<void> clearSavedMahasiswa() async {
    await _storage.clearSavedMahasiswa();
  }
}

// Mahasiswa Notifier Provider
final mahasiswaNotifierProvider =
    StateNotifierProvider.autoDispose<MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>((ref) {
  final repository = ref.watch(mahasiswaRepositoryProvider);
  final storage = ref.watch(mahasiswaLocalStorageServiceProvider);
  return MahasiswaNotifier(repository, storage);
});
