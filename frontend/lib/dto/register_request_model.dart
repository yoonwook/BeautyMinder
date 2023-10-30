class RegisterRequestModel {
  RegisterRequestModel({
    this.email,
    this.password,
    this.nickname,
    this.phoneNumber,
  });

  late final String? email;
  late final String? password;
  late final String? nickname;
  late final String? phoneNumber;


  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    nickname = json['nickname'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['password'] = password;
    _data['nickname'] = nickname;
    _data['phoneNumber'] = phoneNumber;
    return _data;
  }
}
