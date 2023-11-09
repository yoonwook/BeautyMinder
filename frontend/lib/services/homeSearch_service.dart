import 'dart:convert';

import 'package:beautyminder/pages/search/search_page.dart';
import 'package:dio/dio.dart';

import '../config.dart';
import '../dto/cosmetic_model.dart';

class SearchService {
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

  // 이름으로 화장품 검색
  static Future<List<Cosmetic>> searchCosmeticsByName(String name) async {
    final url = '${Config.apiURL}/search/cosmetic?name=$name';
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Cosmetic.fromJson(data)).toList();
    } else {
      throw Exception("Failed to search cosmetics by name");
    }
  }

  // // 콘텐츠로 리뷰 검색
  // static Future<List<Review>> searchReviewsByContent(String content) async {
  //   final url = '${Config.apiURL}/search/review?content=$content';
  //   final response = await client.get(url);
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = response.data;
  //     return jsonData.map((data) => Review.fromJson(data)).toList();
  //   } else {
  //     throw Exception("Failed to search reviews by content");
  //   }
  // }

  // 카테고리로 화장품 검색
  static Future<List<Cosmetic>> searchCosmeticsByCategory(String category) async {
    final url = '${Config.apiURL}/search/category?category=$category';
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Cosmetic.fromJson(data)).toList();
    } else {
      throw Exception("Failed to search cosmetics by category");
    }
  }

  // 키워드로 화장품 검색
  static Future<List<Cosmetic>> searchCosmeticsByKeyword(String keyword) async {
    final url = '${Config.apiURL}/search/keyword?keyword=$keyword';
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Cosmetic.fromJson(data)).toList();
    } else {
      throw Exception("Failed to search cosmetics by keyword");
    }
  }

  // 일반 검색
  static Future<List<Cosmetic>> searchAnything(String anything) async {

    final parameters={
      'anything' : '$anything',
    };

    final url = Uri.http(Config.apiURL, Config.homeSearchKeywordAPI, parameters).toString();

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((data) => Cosmetic.fromJson(data)).toList();
      } else {
        throw Exception("Failed to search cosmetics by keyword");
      }
    } catch (e) {
      print("Error during cosmetics search: $e");
      // return []; // 빈 리스트를 반환하거나 다른 적절한 기본값을 반환할 수 있어요.
      return [];
    }

  }

}