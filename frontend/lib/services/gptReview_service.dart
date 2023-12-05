import 'package:beautyminder/dto/gptReview_model.dart';
import 'package:beautyminder/services/shared_service.dart';

import '../../config.dart';
import 'dio_client.dart';

class GPTReviewService {

  //GPT 리뷰 불러오기
  static Future<GPTResult<GPTReviewInfo>> getGPTReviews(String id) async {

    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(Config.apiURL, '${Config.getGPTReviewAPI}/$id').toString();

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
        final gptReviewInfo = GPTReviewInfo.fromJson(response.data as Map<String, dynamic>);

        return GPTResult.success(gptReviewInfo);
      }
      return GPTResult.failure("Failed to get GPT review information");
    } catch (e) {
      return GPTResult.failure("An error occurred: $e");
    }
  }
}

// 결과 클래스
class GPTResult<T> {
  final T? value;
  final String? error;

  GPTResult.success(this.value) : error = null; // 성공
  GPTResult.failure(this.error) : value = null; // 실패

  bool get isSuccess => value != null;
}
