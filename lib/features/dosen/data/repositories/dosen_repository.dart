import 'package:riverpod_lanjutan/features/dosen/data/models/dosen_model.dart';
import 'package:dio/dio.dart';

class DosenRepository {
  final Dio _dio = Dio();

  /// Mendapatkan daftar dosen
  Future<List<DosenModel>> getDosenList() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/users',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data); // Debug: Tampilkan data yang sudah di-decode
        return data.map((json) => DosenModel.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.data}');
        throw Exception('Gagal memuat data dosen: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error loading data: $e');
    }
  }
}
