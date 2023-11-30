import 'package:dio/dio.dart';

import '../../config.dart';
import 'dio_client.dart';

class EmailVerifyService {

  //이메일 인증 요청
  static Future<Response<dynamic>> emailVerifyRequest(String email) async {

    final parameters = {
      'email': '$email',
    };

    // URL 생성
    final url = Uri.http(Config.apiURL, Config.emailVerifyRequestAPI, parameters).toString();

    try {
      // POST 요청
      final response = await DioClient.sendRequest('POST', url);

      if (response.statusCode == 200) {
        return response;
      }
      throw DioException(
        response: response,
        requestOptions: RequestOptions(path: ''), // Adjust the path accordingly
        error: "Email verification request failed with status code ${response.statusCode}",
      );
    } catch (e) {
      throw DioException(
        response: null,
        requestOptions: RequestOptions(path: ''),
        error: "An error occurred: $e",
      );
    }
  }


  //이메일 인증 토큰 확인 요청
  static Future<Response<dynamic>> emailVerifyTokenRequest(String token) async {
    print("ToTo1");

    final parameters = {
      'token': '$token',
    };

    // URL 생성
    final url = Uri.http(Config.apiURL, Config.emailTokenRequestAPI, parameters).toString();
    print("ToTo2 url : $url");


    try {
      // POST 요청
      final response = await DioClient.sendRequest('POST', url);
      print("ToTo3 response : ${response.statusCode}");

      if (response.statusCode == 200) {
        print("ToTo4 response : ${response.statusCode}");
        return response;
      }
      print("ToTo5");
      throw DioException(
        response: response,
        requestOptions: RequestOptions(path: ''), // Adjust the path accordingly
        error: "Email verification request failed with status code ${response.statusCode}",
      );
    } catch (e) {
      print("ToTo6");
      throw DioException(
        response: null,
        requestOptions: RequestOptions(path: ''),
        error: "An error occurred: $e",
      );
    }
  }

}

// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null;

  Result.failure(this.error) : value = null;

  bool get isSuccess => error == null;

  bool get isFailure => !isSuccess;
}
