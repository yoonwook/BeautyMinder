import 'package:beautyminder/dto/delete_request_model.dart';
import 'package:beautyminder/dto/favorite_model.dart';
import 'package:beautyminder/dto/login_request_model.dart';
import 'package:beautyminder/dto/login_response_model.dart';
import 'package:beautyminder/dto/register_request_model.dart';
import 'package:beautyminder/dto/register_response_model.dart';
import 'package:beautyminder/dto/review_model.dart';
import 'package:beautyminder/dto/update_request_model.dart';
import 'package:dio/dio.dart'; // DIO 패키지를 이용해 HTTP 통신

import '../../config.dart';
import '../dto/user_model.dart';
import 'shared_service.dart';

class APIService {
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

  // POST 방식으로 FormData 데이터 전송하는 일반 함수
  static Future<Response> _postForm(String url, FormData body,
      {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

  // 로그인 함수
  static Future<Result<bool>> login(LoginRequestModel model) async {
    // URL 생성
    final url = Uri.http(Config.apiURL, Config.loginAPI).toString();
    // FormData 생성
    final formData = FormData.fromMap({
      'email': model.email ?? '',
      'password': model.password ?? '',
    });

    try {
      // POST 요청
      print("response:");
      final response = await _postForm(url, formData);
      print("response: $response");
      if (response.statusCode == 200) {
        await SharedService.setLoginDetails(loginResponseJson(response.data));

        return Result.success(true);
      }
      return Result.failure("Login failed");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // 회원가입 함수
  static Future<Result<RegisterResponseModel>> register(
      RegisterRequestModel model) async {
    // URL 생성
    final url = Uri.http(Config.apiURL, Config.registerAPI).toString();

    try {
      // POST 요청
      final response = await _postJson(url, model.toJson());
      return Result.success(
          registerResponseJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

// 탈퇴 함수
  static Future<Result<bool>> delete(DeleteRequestModel model) async {
    // 로그인 상세 정보 가져오기
    final user = await SharedService.getUser();
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();
    final userId = user?.id ?? '-1';

    // URL 생성
    final url = Uri.http(Config.apiURL, Config.deleteAPI + userId).toString();

    // 헤더 설정
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken', // 리프레시 토큰 적용
    };

    try {
      final response = await client.delete(
        url,
        options: _httpOptions('DEL', headers),
      );
      return Result.success(true);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // 사용자 프로필 조회 함수
  static Future<Result<User>> getUserProfile() async {
    // 로그인 상세 정보 가져오기
    // final user = await SharedService.getUser();
    // final accessToken = await SharedService.getAccessToken();
    // final refreshToken = await SharedService.getRefreshToken();
    // final userId = user?.id ?? '-1';

    // 유저 정보 가지고 오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    // final accessToken = await SharedService.getAccessToken();
    final accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMDU0OTQzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.-tq20j-ZRmL9WRdBZEPrELjpxrbOJ0JUztzfGHCwLKM";
    //refreshToken 가지고오기
    // final refreshToken = await SharedService.getRefreshToken();
    final refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMTE1NDIzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.dAXFUJI2vpjiQKakrRC_UTqgpG_BD_Df4vOeQq46HWQ";

    // user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
    final userId = user?.id ?? '-1';

    // URL 생성
    final url =
        Uri.http(Config.apiURL, Config.userProfileAPI).toString();

    // 헤더 설정
    // final headers = {
    //   'Authorization': 'Bearer $accessToken',
    //   'Cookie': 'XRT=$refreshToken', // 리프레시 토큰 적용
    // };
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      // GET 요청
      final response = await client.get(
        url,
        options: _httpOptions('GET', headers),
      );

      if (response.statusCode == 200) {
        // 사용자 정보 파싱
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return Result.success(user);
      }

      return Result.failure("Failed to get user profile");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // 즐겨찾기 조회 함수
  static Future<Result<FavoriteModel>> getFavorites() async {
    // 로그인 상세 정보 가져오기
    // final user = await SharedService.getUser();
    // final accessToken = await SharedService.getAccessToken();
    // final refreshToken = await SharedService.getRefreshToken();
    // final userId = user?.id ?? '-1';

    // 유저 정보 가지고 오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    // final accessToken = await SharedService.getAccessToken();
    final accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMDU0OTQzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.-tq20j-ZRmL9WRdBZEPrELjpxrbOJ0JUztzfGHCwLKM";
    //refreshToken 가지고오기
    // final refreshToken = await SharedService.getRefreshToken();
    final refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMTE1NDIzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.dAXFUJI2vpjiQKakrRC_UTqgpG_BD_Df4vOeQq46HWQ";

    // user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
    final userId = user?.id ?? '-1';

    // URL 생성
    final url =
        Uri.http(Config.apiURL, '/user/favorites').toString();

    // 헤더 설정
    // final headers = {
    //   'Authorization': 'Bearer $accessToken',
    //   'Cookie': 'XRT=$refreshToken', // 리프레시 토큰 적용
    // };
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      // GET 요청
      final response = await client.get(
        url,
        options: _httpOptions('GET', headers),
      );

      if (response.statusCode == 200) {
        // 사용자 정보 파싱
        print('res:' + response.data.toString());
        final favorites =
            FavoriteModel.fromJson(response.data as Map<String, dynamic>);
        return Result.success(favorites);
      }

      return Result.failure("Failed to get user favorites");
    } catch (e) {
      print(e);
      return Result.failure("An error occurred: $e");
    }
  }

  // 리뷰 조회 함수
  static Future<Result<List<dynamic>>> getReviews() async {
    // 로그인 상세 정보 가져오기
    // final user = await SharedService.getUser();
    // final accessToken = await SharedService.getAccessToken();
    // final refreshToken = await SharedService.getRefreshToken();
    // final userId = user?.id ?? '-1';
    // 유저 정보 가지고 오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    // final accessToken = await SharedService.getAccessToken();
    final accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMDU0OTQzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.-tq20j-ZRmL9WRdBZEPrELjpxrbOJ0JUztzfGHCwLKM";
    //refreshToken 가지고오기
    // final refreshToken = await SharedService.getRefreshToken();
    final refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMTE1NDIzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.dAXFUJI2vpjiQKakrRC_UTqgpG_BD_Df4vOeQq46HWQ";

    // user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
    final userId = user?.id ?? '-1';

    // URL 생성
    final url =
        Uri.http(Config.apiURL, '/user/reviews').toString();

    // 헤더 설정
    // final headers = {
    //   'Authorization': 'Bearer $accessToken',
    //   'Cookie': 'XRT=$refreshToken', // 리프레시 토큰 적용
    // };
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      // GET 요청
      final response = await client.get(
        url,
        options: _httpOptions('GET', headers),
      );

      if (response.statusCode == 200) {
        return Result.success(response.data);
      }

      return Result.failure("Failed to get user reviews");
    } catch (e) {
      print(e);
      return Result.failure("An error occurred: $e");
    }
  }

  // 회원정보 수정 함수
  static Future<Result<bool>> sendEditInfo(UpdateRequestModel model) async {
    // 로그인 상세 정보 가져오기
    // final user = await SharedService.getUser();
    // final accessToken = await SharedService.getAccessToken();
    // final refreshToken = await SharedService.getRefreshToken();
    // final userId = user?.id ?? '-1';
    // 유저 정보 가지고 오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    // final accessToken = await SharedService.getAccessToken();
    final accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMDU0OTQzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.-tq20j-ZRmL9WRdBZEPrELjpxrbOJ0JUztzfGHCwLKM";
    //refreshToken 가지고오기
    // final refreshToken = await SharedService.getRefreshToken();
    final refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE2OTk5NDQ2MzksImV4cCI6MTcwMTE1NDIzOSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.dAXFUJI2vpjiQKakrRC_UTqgpG_BD_Df4vOeQq46HWQ";

    // user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
    final userId = user?.id ?? '-1';

    // URL 생성
    final url =
        Uri.http(Config.apiURL, Config.userProfileAPI).toString();

    // 헤더 설정
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken', // 리프레시 토큰 적용
    };

    try {
      final response = await _postJson(url, model.toJson());
      return Result.success(true);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }
}

// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패
}
