import 'dart:convert';

import 'package:beautyminder/config.dart';
import 'package:beautyminder/dto/Cosmetic.dart';
import 'package:beautyminder/models/CosmeticModel.dart';
import 'package:beautyminder/services/auth_service.dart';
import 'package:beautyminder/services/dio_client.dart';
import 'package:beautyminder/services/shared_service.dart';
import 'package:dio/dio.dart';

class CosmeticSearchService{

  // Get All Cosmetics
   static Future<Result<List<CosmeticModel>>> getAllCosmetics() async {
    // 유저 정보 가지고 오기
    final user = await SharedService.getUser();
    // AccessToken가지고오기
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

     // user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
     final userId = user?.id ?? '-1';

    // final url = Uri.http(Config.apiURL, Config.CosmeticAPI).toString();
    final url = Uri.http(Config.apiURL, Config.RecommendAPI).toString();
    print("url : ${url}");


    final headers = {
      'Authorization': 'Bearer ${Config.acccessToken}',
      'Cookie': 'XRT=${Config.refreshToken}',
      // 'Authorization': 'Bearer $accessToken',
      // 'Cookie': 'XRT=$refreshToken',
    };

    try{

      final response = await DioClient.sendRequest('GET', url,headers: headers);

      print("response : ${response.data}, statuscode : ${response.statusCode}");

      //print("token : $accessToken | $refreshToken");
      print("statuscode : ${response.statusCode}");

      if(response.statusCode == 200){

        Map<String, dynamic> decodedResponse;

        if(response.data is List){
          List<dynamic> dataList = response.data;
          //print("dataList : ${dataList}");
          List<CosmeticModel> cosmetics = dataList.map<CosmeticModel>((data) {
            if(data is Map<String, dynamic>){
              return CosmeticModel.fromJson(data);
            }else{
              throw Exception("Invalid data type");
            }
          }).toList();


          return Result.success(cosmetics);

        }else if(response.data is Map){
          print("data is Map");
          decodedResponse = response.data;
        }else {
          print("failure");
          return Result.failure("Unexpected response data type");
        }

          return Result.failure("Failed to serach Cosmetics : No cosmetics key in response");
        }
        return Result.failure("Failed to ge cosmeics");
      }catch(e){
      print("CosmeticSearch_Service : ${e}");
      return Result.failure("An error Occured : $e");


    }
    }


}



class Result<T>{
  //T는 제네릭타입 반환 타입에 가변적으로 타입을 맞춰줌
  final T? value;
  final String? error;

  Result.success(this.value) : error =null;
  Result.failure(this.error) : value = null;
}