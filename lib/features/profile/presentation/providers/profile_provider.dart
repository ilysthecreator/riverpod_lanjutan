import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/features/profile/data/models/profile_model.dart';

class ProfileNotifier extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() async {
    return _fetchProfile();
  }

  Future<ProfileModel> _fetchProfile() async {
    // Simulasi delay
    await Future.delayed(const Duration(seconds: 1));

    return ProfileModel(
      nama: 'Admin D4TI',
      email: 'admin.d4ti@vokasi.id',
      role: 'Administrator',
      phone: '+62 812-3456-7890',
      joinDate: 'Agustus 2023',
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfile());
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileModel>(() {
  return ProfileNotifier();
});
