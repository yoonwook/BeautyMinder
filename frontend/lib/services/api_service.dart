import 'package:beautyminder/dto/login_request_model.dart';
import 'package:beautyminder/dto/login_response_model.dart';
import 'package:beautyminder/dto/register_request_model.dart';
import 'package:beautyminder/dto/register_response_model.dart';
import 'package:dio/dio.dart';  // DIO 패키지를 이용해 HTTP 통신

import '../../config.dart';
import '../dto/user_model.dart';
import 'shared_service.dart';
import 'package:beautyminder/util/result.dart';

class APIService {
  static final Dio client = Dio();

  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
    );
  }

  static Future<Response> _postJson(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

  static Future<Response> _postForm(
      String url, FormData body, {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

  static Future<Result<bool>> login(LoginRequestModel model) async {
    print("sfdf1d");
    final url = Uri.parse('${Config.apiURL}${Config.loginAPI}').toString();
    print("${model.email} is ${model.password}");
    final formData = FormData.fromMap({
      'email': model.email ?? '',
      'password': model.password ?? '',
    });
    print("sfdfd");

    try {
      final response = await _postForm(url, formData);
      if (response.statusCode == 200) {
        await SharedService.setLoginDetails(loginResponseJson(response.data));
        return Result.success(true);
      }
      return _handleFailure<bool>(response);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  static Future<Result<RegisterResponseModel>> register(RegisterRequestModel model) async {
    final url = '${Config.apiURL}${Config.registerAPI}';

    try {
      final response = await _postJson(url, model.toJson());
      if (response.statusCode == 200) {
        return Result.success(
            registerResponseJson(response.data as Map<String, dynamic>));
      }
      return _handleFailure<RegisterResponseModel>(response);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  static Future<Result<User>> getUserProfile() async {
    final user = await SharedService.getUser();
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();
    final userId = user?.id ?? '-1';

    final url = '${Config.apiURL}${Config.userProfileAPI}$userId';

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await client.get(
        url,
        options: _httpOptions('GET', headers),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return Result.success(user);
      }
      return _handleFailure<User>(response);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }


  static Result<T> _handleFailure<T>(Response response) {
    if ((response.statusCode ?? 0) >= 400 && (response.statusCode ?? 0) < 500) {
      String errorMessage = "Client request error";
      if (response.data != null && response.data.containsKey('message')) {
        errorMessage = response.data['message'];
      }
      return Result.failure(errorMessage);
    } else if ((response.statusCode ?? 0) >= 500) {
      return Result.failure("Server error");
    }
    return Result.failure("An error occurred.");
  }
}


