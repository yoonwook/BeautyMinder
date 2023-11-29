import 'package:beautyminder/services/shared_service.dart';
import 'package:dio/dio.dart';

import '../config.dart';
import '../dto/cosmetic_expiry_model.dart';

class ExpiryService {
  static final Dio client = Dio();

  // static String accessToken = Config.acccessToken;
  // static String refreshToken = Config.refreshToken;
  static String accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDExNzk4MTQsImV4cCI6MTcwMzc3MTgxNCwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU2NWYxMDE3Zjk4NzRlNzQ5ZmNkMzJlIn0.gRjvkNVIRXlAhngM2cgNROEIFwhFmrkqzJQIRHcEAys";
  static String refreshToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDExNzk4MTQsImV4cCI6MTcwMzc3MTgxNCwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU2NWYxMDE3Zjk4NzRlNzQ5ZmNkMzJlIn0.gRjvkNVIRXlAhngM2cgNROEIFwhFmrkqzJQIRHcEAys';

  // 액세스 토큰 설정
  static void setAccessToken() {
    client.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
    );
  }

  // Create Expiry Item
  // Create Expiry Item
  static Future<CosmeticExpiry> createCosmeticExpiry(
      CosmeticExpiry expiry) async {
    setAccessToken();

    final url =
        Uri.http(Config.apiURL, Config.createCosmeticExpiryAPI).toString();

    try {
      final response = await client.post(url,
          options: _httpOptions('POST', jsonHeaders), data: expiry.toJson());
      if (response.statusCode == 200) {
        return CosmeticExpiry.fromJson(response.data);
      } else {
        // 에러 메시지에 응답 본문을 포함시킵니다.
        throw Exception(
            "Failed to create cosmetic expiry: Status Code ${response.statusCode}, Data: ${response.data}");
      }
    } on DioException catch (e) {
      // DioError를 캐치하여 더 많은 정보를 로그로 남깁니다.
      print('DioError caught: ${e.response?.data}');
      print('Headers: ${e.response?.headers}');
      print('Request Options: ${e.response?.requestOptions}');
      throw Exception("Failed to create cosmetic expiry: ${e.message}");
    }
  }

  // Get all Expiry Items
  static Future<List<CosmeticExpiry>> getAllExpiries() async {
    setAccessToken();
    final url = Uri.http(Config.apiURL, Config.getAllExpiriesAPI).toString();
    // final url = '${Config.apiURL}/expiry';
    try {
      final response =
          await client.get(url, options: _httpOptions('GET', jsonHeaders));
      print('Response data: ${response.data}'); // 로깅 추가
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => CosmeticExpiry.fromJson(data)).toList();
      } else {
        throw Exception(
            "Failed to get expiries : Status Code ${response.statusCode}");
      }
    } on DioError catch (e) {
      throw Exception("DioError: ${e.message}");
    }
  }

  // Get an expiry item by and ExpiryId
  static Future<CosmeticExpiry> getExpiry(String expiryId) async {
    setAccessToken();
    final url = Uri.http(
            Config.apiURL, Config.getExpiryByUserIdandExpiryIdAPI + expiryId)
        .toString();
    // final url = '${Config.apiURL}/expiry/$expiryId';
    try {
      final response =
          await client.get(url, options: _httpOptions('GET', jsonHeaders));
      if (response.statusCode == 200) {
        return CosmeticExpiry.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to get expiry by expiry ID: Status Code ${response.statusCode}");
      }
    } on DioError catch (e) {
      throw Exception("DioError: ${e.message}");
    }
  }

  // Update an
  static Future<CosmeticExpiry> updateExpiry(String expiryId, CosmeticExpiry updatedExpiry) async {

    // 로그인 상세 정보 가져오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final userId = user?.id ?? '-1';

    final url = Uri.http(
            Config.apiURL, Config.getExpiryByUserIdandExpiryIdAPI + expiryId).toString();

    // 헤더 설정
    final headers = {
      'Authorization': 'Bearer ${Config.acccessToken}',
      'Cookie': 'XRT=${Config.refreshToken}',
      // 'Authorization': 'Bearer $accessToken',
      // 'Cookie': 'XRT=$refreshToken',
    };

    try {
      print("*** 1 : ${updatedExpiry.opened}");
      print("*** 2 : ${updatedExpiry.toJson()}");

      final response = await client.put(
        url,
        options: _httpOptions('PUT', headers),
        data: updatedExpiry.toJson()
      );
      print("*** 2.5 : ${updatedExpiry.toJson()}");
      print("*** 3 : ${response.data}");

      print("1122Server Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        print("이원준5");
        print("1133Server Response: ${response.statusCode} - ${response.data}");
        return CosmeticExpiry.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to update expiry: Status Code ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("DioError: ${e.message}");
    }
  }

  // Delete an expiry item by and ExpiryId
  static Future<void> deleteExpiry(String expiryId) async {
    setAccessToken();
    final url = Uri.http(
            Config.apiURL, Config.getExpiryByUserIdandExpiryIdAPI + expiryId)
        .toString();
    // final url = '${Config.apiURL}/expiry/$expiryId';
    try {
      final response = await client.delete(url,
          options: _httpOptions('DELETE', jsonHeaders));
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to delete expiry: Status Code ${response.statusCode}");
      }
    } on DioError catch (e) {
      throw Exception("DioError: ${e.message}");
    }
  }
}
