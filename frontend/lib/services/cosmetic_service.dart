import 'package:dio/dio.dart';
import '../config.dart';
import '../dto/cosmetic_model.dart';

class CosmeticService {
  static final Dio client = Dio();
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // 모든 화장품 정보 가져오기
  static Future<List<Cosmetic>> getAllCosmetics() async {
    final url = Uri.http(Config.apiURL, 'cosmetic').toString();
    final response = await client.get(url, options: _httpOptions('GET', jsonHeaders));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Cosmetic.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load cosmetics");
    }
  }

  // 특정 화장품 정보 가져오기
  static Future<Cosmetic> getCosmeticById(String id) async {
    final url = Uri.http(Config.apiURL, 'cosmetic/$id').toString();
    final response = await client.get(url, options: _httpOptions('GET', jsonHeaders));
    if (response.statusCode == 200) {
      return Cosmetic.fromJson(response.data);
    } else {
      throw Exception("Failed to get cosmetic by ID");
    }
  }

  // 화장품 추가하기
  static Future<Cosmetic> addCosmetic(Cosmetic cosmetic) async {
    final url = Uri.http(Config.apiURL, 'cosmetic').toString();
    final response = await client.post(url, options: _httpOptions('POST', jsonHeaders), data: cosmetic.toJson());
    if (response.statusCode == 200) {
      return Cosmetic.fromJson(response.data);
    } else {
      throw Exception("Failed to add cosmetic");
    }
  }

  // 화장품 수정하기
  static Future<Cosmetic> updateCosmetic(String id, Cosmetic cosmetic) async {
    final url = Uri.http(Config.apiURL, 'cosmetic/$id').toString();
    final response = await client.put(url, options: _httpOptions('PUT', jsonHeaders), data: cosmetic.toJson());
    if (response.statusCode == 200) {
      return Cosmetic.fromJson(response.data);
    } else {
      throw Exception("Failed to update cosmetic");
    }
  }

  // 화장품 삭제하기
  static Future<void> deleteCosmetic(String id) async {
    final url = Uri.http(Config.apiURL, 'cosmetic/$id').toString();
    final response = await client.delete(url, options: _httpOptions('DELETE', jsonHeaders));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete cosmetic");
    }
  }

  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
    );
  }
}

