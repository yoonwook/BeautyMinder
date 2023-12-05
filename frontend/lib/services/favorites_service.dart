import 'package:beautyminder/services/shared_service.dart';

import '../../config.dart';
import 'api_service.dart';
import 'dio_client.dart';

class FavoritesService {

  //좋아요 등록하기
  static Future<String> uploadFavorites(String cosmeticId) async {

    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(Config.apiURL, Config.uploadFavoritesAPI + cosmeticId).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await DioClient.sendRequest(
          'POST',
          url,
          headers: headers
      );

      if (response.statusCode == 200) {
        return "success upload user favorites";
      }
      return "Failed to upload user favorites";
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  //좋아요 삭제하기
  static Future<String> deleteFavorites(String cosmeticId) async {

    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(Config.apiURL, Config.uploadFavoritesAPI + cosmeticId).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await DioClient.sendRequest(
          'DELETE',
          url,
          headers: headers
      );

      if (response.statusCode == 200) {
        return "success deleted user favorites";
      }
      return "Failed to deleted user favorites";
    } catch (e) {
      return "An error occurred: $e";
    }
  }


  // 즐겨찾기 제품 조회
  static Future<Result<List<dynamic>>> getFavorites() async {
    /// 로그인 상세 정보 가져오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final userId = user?.id ?? '-1';

    // URL 생성
    final url = Uri.http(Config.apiURL, '/user/favorites').toString();

    // 헤더 설정
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      // GET 요청
      final response = await DioClient.sendRequest(
        'GET',
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {

        return Result.success(response.data);
      }

      return Result.failure("Failed to get user favorites");
    } catch (e) {
      print(e);
      return Result.failure("An error occurred: $e");
    }
  }
}
