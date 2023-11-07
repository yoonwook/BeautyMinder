import 'package:beautyminder/dto/baumann_model.dart';
import 'package:dio/dio.dart';

import '../../config.dart';

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

  //POST 방식으로 JSON 데이터 전송하는 일반 함수
  static Future<Response> postJson(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

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



  // static Future<Result<ResultWrapper>> getBaumannResults() async {
  //   // URL 생성
  //   final url = Uri.http(Config.apiURL, Config.baumannTestAPI).toString();
  //
  //   try {
  //     // GET 요청
  //     final response = await client.get(
  //       url,
  //       // options: _httpOptions('GET', headers),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // 사용자 정보 파싱
  //       final user = ResultWrapper.fromJson(response.data as Map<String, dynamic>);
  //       print(user);
  //       return Result.success(user);
  //     }
  //     return Result.failure("Failed to get user profile");
  //   } catch (e) {
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
