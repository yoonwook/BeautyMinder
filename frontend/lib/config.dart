import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static const String appName = "BeautyMinder";
  static String get apiURL {
    if (kIsWeb) {
      return "http://211.221.220.124:8080";
    }
    if (Platform.isAndroid) {
      return 'http://211.221.220.124:8080';
    } else {
      return 'http://211.221.220.124:8080';
    }
  }

  static const loginAPI = "/login";
  static const registerAPI = "/user/signup";
  static const userProfileAPI = "/user/me/";

  // Todo
  static const todoAPI = "/todo/all";
  static const todoAddAPI = "/todo/add";
  static const todoDelAPI = "/todo/delete/";

  // Cosmetic
  static const cosmeticAPI = "/cosmetic";
  static const cosmeticByIdAPI = "/cosmetic/";  //
  static const cosmeticAddAPI = "/cosmetic";    //
  static const cosmeticUpdateAPI = "/cosmetic/"; //
  static const cosmeticDeleteAPI = "/cosmetic/"; //


}


