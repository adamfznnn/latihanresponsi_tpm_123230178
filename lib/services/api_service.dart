import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/space_models.dart';

class ApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  // 1. Fungsi untuk mengambil LIST data (News, Blog, atau Report)
  Future<SpaceResponse> fetchListData(String menuType) async {
    final url = Uri.parse('$_baseUrl/$menuType/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpaceResponse.fromJson(data);
      } else {
        throw Exception('Gagal memuat daftar data $menuType');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  // 2. Fungsi untuk mengambil DETAIL data berdasarkan ID
  Future<SpaceModel> fetchDetailData(String menuType, int id) async {
    final url = Uri.parse('$_baseUrl/$menuType/$id/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpaceModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail data (ID: $id)');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}