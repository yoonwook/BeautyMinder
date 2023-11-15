import 'package:beautyminder/services/shared_service.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../dto/keywordRank_model.dart';

class KeywordRankService {
  // Dio 객체 생성
  // static final Dio client = Dio();
  static final Dio client = Dio(BaseOptions(
    connectTimeout: Duration(milliseconds: 1000), // milliseconds
    receiveTimeout: Duration(milliseconds: 1000), // milliseconds
  ));

  // JSON 헤더 설정
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // 공통 HTTP 옵션 설정 함수
  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
      receiveTimeout: const Duration(milliseconds: 1000),
      sendTimeout: const Duration(milliseconds: 1000),
    );
  }

  static Future<Result<KeyWordRank>> getKeywordRank() async {

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
    final url = Uri.http(Config.apiURL, Config.keywordRankAPI).toString();

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
        final user = KeyWordRank.fromJson(response.data);
        print('heloo : ${response.data}');
        return Result.success(user);
      }

      return Result.failure("Failed to get user profile");

    } catch (e) {
      //
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        return Result.failure("Connection timed out");
      }
      //
      return Result.failure("An error occurred: $e");
    }
  }


  static Future<Result<ProductRank>> getProductRank() async {
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
    final url = Uri.http(Config.apiURL, Config.productRankAPI).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      // GET 요청
      final response = await client.get(
          url,
          //
          options: _httpOptions('GET', headers),
        //
      );

      if (response.statusCode == 200) {
        // 사용자 정보 파싱
        final user = ProductRank.fromJson(response.data);
        print('heloo : ${response.data}');
        return Result.success(user);
      }

      return Result.failure("Failed to get user profile");

    } catch (e) {
      //
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        return Result.failure("Connection timed out");
      }
      //
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

  bool get isSuccess => value != null;
}
