import 'dart:io' show Platform;
import 'package:beautyminder/globalVariable/globals.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static const String appName = "BeautyMinder";
  static String get apiURL {
    if (kIsWeb) {
      return "211.221.220.124:8080";
    }
    if (Platform.isAndroid) {
      return '211.221.220.124:8080';
    } else {
      return '211.221.220.124:8080';
    }
  }

  static const loginAPI = "/login";
  static const registerAPI = "/user/signup";
  static const deleteAPI = "/user/delete";
  static const userProfileAPI = "/user/me";
  static const editUserInfo = "/user/update";
  static const editProfileImg = "user/upload";

  // Todo
  static const todoAPI = "/todo/all";
  static const todoAddAPI = "/todo/add";
  static const todoDelAPI = "/todo/delete/";

  //Baumann
  static const baumannSurveyAPI = "/baumann/survey";
  static const baumannTestAPI = "/baumann/test";

  //rank
  static const keywordRankAPI = "/redis/top/keywords";
  static const productRankAPI = "/redis/top/cosmetics";

  //search
  static const homeSearchKeywordAPI = "/search";
  static const searchReviewbyContentAPI = "/search/review";
  static const searchCosmeticsbyKeyword = "/search/keyword";
  static const searchCosmeticsbyName = "/search/cosmetic";
  static const searchCosmeticsbyCategory = "/search/category";

  //gpt review
  static const getGPTReviewAPI = "gpt/review";

  // Cosmetic
  static const CosmeticAPI = "/cosmetic";

  // Recommend
  static const RecommendAPI = "/recommend";

  //review
  static const AllReviewAPI = "/review";
  static const getReviewAPI = "/review/";
  static const ReviewImageAPI = "/review/image";

  //expiry
  static const createCosmeticExpiryAPI = "/expiry/create";
  static const getAllExpiryByUserIdAPI = "/expiry/user/";
  static const getExpiryByUserIdandExpiryIdAPI = "/expiry/";

  //favorites
  static const uploadFavoritesAPI = "/user/favorites/";
}
