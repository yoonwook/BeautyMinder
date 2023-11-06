import 'dart:convert';

import 'package:beautyminder/dto/baumann_model.dart';
import 'package:beautyminder/services/auth_service.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import 'shared_service.dart';

class BaumannService {
  // Dio 객체 생성
  static final Dio client = Dio();

  // JSON 헤더 설정
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // 공통 HTTP 옵션 설정 함수
  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
    );
  }

  // POST 방식으로 JSON 데이터 전송하는 일반 함수
  static Future<Response> _postJson(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

  //new
  static Future<Result<SurveyWrapper>> getBaumannSurveys() async {
    // URL 생성
    final url = Uri.http(Config.apiURL, Config.baumannSurveyAPI).toString();

    try {
      // GET 요청
      final response = await client.get(
        url,
        // options: _httpOptions('GET', headers),
      );

      if (response.statusCode == 200) {
        // 사용자 정보 파싱
        final user = SurveyWrapper.fromJson(response.data as Map<String, dynamic>);
        print(user);
        return Result.success(user);
      }
      return Result.failure("Failed to get user profile");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }



  // // 설문조사 데이터 받기
  // static Future<Result<List<BaumannSurveys>>> getBaumannSurveys() async {
  //   // final user = await SharedService.getUser();
  //   final accessToken = await SharedService.getAccessToken();
  //   final refreshToken = await SharedService.getRefreshToken();
  //   // final userId = user?.id ?? '-1';
  //
  //   // Create the URI with the query parameter
  //   final url =
  //   Uri.http(Config.apiURL, Config.baumannSurveyAPI).toString();
  //
  //   final headers = {
  //     'Authorization': 'Bearer $accessToken',
  //     'Cookie': 'XRT=$refreshToken',
  //   };
  //
  //   try {
  //     final response = await authClient.get(
  //       url,
  //       options: _httpOptions('GET', headers),
  //     );
  //
  //     print("response: ${response.data} ${response.statusCode}");
  //     print("token: $accessToken | $refreshToken");
  //
  //     if (response.statusCode == 200) {
  //       // JSON 데이터를 파싱하여 Baumann 모델로 변환
  //       // final decodedResponse = json.decode(json.encode(response.data));
  //       // final decodedResponse = json.decode(response.data);
  //       // final baumannData = BaumannSurveys.fromJson(decodedResponse);
  //       final baumannData = BaumannSurveys.fromJson(response.data);
  //
  //       print("Baumann data: $baumannData");
  //       return Result.success(baumannData as List<BaumannSurveys>?);
  //     }
  //     else {
  //       return Result.failure("Failed to get Baumann data");
  //     }
  //   } catch (e) {
  //     print("error : ${e}");
  //     return Result.failure("An error occurred: $e");
  //   }
  // }
}

// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패

  bool get isSuccess => value != null;
}
