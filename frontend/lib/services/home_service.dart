import 'package:beautyminder/dto/user_model.dart';
import 'package:beautyminder/services/shared_service.dart';

import '../../config.dart';
import 'dio_client.dart';

class HomeService {

  static Future<HomePageResult<User>> getUserInfo(String userId) async {

    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(Config.apiURL, Config.getUserInfo + userId).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await DioClient.sendRequest(
          'GET',
          url,
          headers: headers
      );

      if (response.statusCode == 200) {
        // 사용자 정보 파싱
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return HomePageResult.success(user);
      }
      return HomePageResult.failure("Failed to get user profile");
    } catch (e) {
      return HomePageResult.failure("An error occurred: $e");
    }
  }
}

// 결과 클래스
class HomePageResult<T> {
  final T? value;
  final String? error;

  HomePageResult.success(this.value) : error = null; // 성공
  HomePageResult.failure(this.error) : value = null; // 실패

  bool get isSuccess => value != null;
}
