import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _savedUsersKey = 'saved_users';
  static const String _savedMahasiswaKey = 'saved_mahasiswa';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveUser({
    required String userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // --- simpan user di list (Dosen) -------------------------
  /// Tambah user ke list (tidak menghapus yang lama)
  Future<void> addUserToSavedList({
    required String userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedUsersKey) ?? [];

    // Cek duplikasi userId
    final isDuplicate = rawList.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    if (isDuplicate) return; // Jika sudah ada, lewati

    final newUser = jsonEncode({
      'user_id': userId,
      'username': username,
      'saved_at': DateTime.now().toIso8601String(),
    });

    rawList.add(newUser);
    await prefs.setStringList(_savedUsersKey, rawList);
  }

  /// Ambil semua user yang sudah disimpan
  Future<List<Map<String, String>>> getSavedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedUsersKey) ?? [];

    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return {
        'user_id': (map['user_id'] ?? '').toString(),
        'username': (map['username'] ?? '').toString(),
        'saved_at': (map['saved_at'] ?? '').toString(),
      };
    }).toList();
  }

  /// delete user tertentu dari list
  Future<void> removeSavedUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedUsersKey) ?? [];

    rawList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    await prefs.setStringList(_savedUsersKey, rawList);
  }

  /// delete semua user dari list
  Future<void> clearSavedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedUsersKey);
  }

  // --- simpan mahasiswa di list -------------------------
  /// Tambah mahasiswa ke list (tidak menghapus yang lama)
  Future<void> addMahasiswaToSavedList({
    required String id,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    // Cek duplikasi id
    final isDuplicate = rawList.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'] == id;
    });

    if (isDuplicate) return;

    final newMahasiswa = jsonEncode({
      'id': id,
      'name': name,
      'saved_at': DateTime.now().toIso8601String(),
    });

    rawList.add(newMahasiswa);
    await prefs.setStringList(_savedMahasiswaKey, rawList);
  }

  /// Ambil semua mahasiswa yang sudah disimpan
  Future<List<Map<String, String>>> getSavedMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return {
        'id': (map['id'] ?? '').toString(),
        'name': (map['name'] ?? '').toString(),
        'saved_at': (map['saved_at'] ?? '').toString(),
      };
    }).toList();
  }

  /// delete mahasiswa tertentu dari list
  Future<void> removeSavedMahasiswa(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    rawList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'] == id;
    });

    await prefs.setStringList(_savedMahasiswaKey, rawList);
  }

  /// delete semua mahasiswa dari list
  Future<void> clearSavedMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedMahasiswaKey);
  }

  // --- Clear all preferences -------------------------
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
