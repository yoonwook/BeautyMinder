import 'dart:io' show Platform;
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

  //home
  static const getUserInfo = "user/me/";

  // Todo
  static const Todo = "/todo";
  static const todoAPI = "/todo/all";
  static const todoAddAPI = "/todo/create";
  static const todoDelAPI = "/todo/delete/";
  static const todoUpdateAPI = "/todo/update/";

  //Baumann
  static const baumannSurveyAPI = "/baumann/survey";
  static const baumannTestAPI = "/baumann/test";
  static const baumannHistoryAPI = "/baumann/history";

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

  static const acccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDA1NTA3MjUsImV4cCI6MTcwMTc2MDMyNSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.MESeOCDgBOPiXj9Zn-UiFqSbN0Oo30cEibwk__7IZEo";
  static const refreshToken= "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDA1NTA3MjUsImV4cCI6MTcwMjM2NTEyNSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.Pl1s8CyrVYDeBor4gtD4i6ibt1CI0tDVU9bipqP5ozI";
}
