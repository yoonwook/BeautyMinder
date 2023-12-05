import 'package:beautyminder/services/auth_service.dart';
import 'package:beautyminder/services/dio_client.dart';
import 'package:beautyminder/services/shared_service.dart';
import 'package:dio/dio.dart';

import '../config.dart';
import '../dto/cosmetic_model.dart';

class CosmeticSearchService {
  static final Dio client = Dio();

  // JSON 헤더 설정
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // Get All Cosmetics
  static Future<Result<List<Cosmetic>>> getAllCosmetics() async {
    // 로그인 상세 정보 가져오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final userId = user?.id ?? '-1';

    final url = Uri.http(Config.apiURL, Config.RecommendAPI).toString();

    // 헤더 설정
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response =
          await DioClient.sendRequest('GET', url, headers: headers);

      print("response : ${response.data}, statuscode : ${response.statusCode}");

      //print("token : $accessToken | $refreshToken");
      print("statuscode : ${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse;

        if (response.data is List) {
          List<dynamic> dataList = response.data;
          //print("dataList : ${dataList}");
          List<Cosmetic> cosmetics = dataList.map<Cosmetic>((data) {
            if (data is Map<String, dynamic>) {
              return Cosmetic.fromJson(data);
            } else {
              throw Exception("Invalid data type");
            }
          }).toList();

          return Result.success(cosmetics);
        } else if (response.data is Map) {
          print("data is Map");
          decodedResponse = response.data;
        } else {
          print("failure");
          return Result.failure("Unexpected response data type");
        }

        return Result.failure(
            "Failed to serach Cosmetics : No cosmetics key in response");
      }
      return Result.failure("Failed to ge cosmeics");
    } catch (e) {
      print("CosmeticSearch_Service : ${e}");
      return Result.failure("An error Occured : $e");
    }
  }
}

class Result<T> {
  //T는 제네릭타입 반환 타입에 가변적으로 타입을 맞춰줌
  final T? value;
  final String? error;

  Result.success(this.value) : error = null;

  Result.failure(this.error) : value = null;
}
