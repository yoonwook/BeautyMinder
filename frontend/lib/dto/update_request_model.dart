import 'package:cross_file/src/types/interface.dart';

class UpdateRequestModel {
  UpdateRequestModel({this.nickname, this.password, this.phone, this.image}); // 변경

  late final String? nickname;
  late final String? password;
  late final String? phone;
  late final XFile? image;

  UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    password = json['password'];
    phone = json['phone'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nickname'] = nickname;
    _data['password'] = password;
    _data['phone'] = phone;
    _data['image'] = image;
    return _data;
  }
}
