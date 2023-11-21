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
  static const userProfileAPI = "/user/me/";

  // Todo
  static const Todo = "/todo";
  static const todoAPI = "/todo/all";
  static const todoAddAPI = "/todo/create";
  static const todoDelAPI = "/todo/delete/";
  static const todoUpdateAPI = "/todo/update/";

  // Cosmetic
  static const CosmeticAPI = "/cosmetic";

  // Recommend
  static const RecommendAPI = "/recommend";

  static const acccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDA1NTA3MjUsImV4cCI6MTcwMTc2MDMyNSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.MESeOCDgBOPiXj9Zn-UiFqSbN0Oo30cEibwk__7IZEo";
  static const refreshToken= "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWF1dHltaW5kZXIiLCJpYXQiOjE3MDA1NTA3MjUsImV4cCI6MTcwMjM2NTEyNSwic3ViIjoidG9rZW5AdGVzdCIsImlkIjoiNjU1MGFmZWYxYWI2ZDU4YjNmMTVmZTFjIn0.Pl1s8CyrVYDeBor4gtD4i6ibt1CI0tDVU9bipqP5ozI";
}
