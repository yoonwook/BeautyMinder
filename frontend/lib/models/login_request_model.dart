class LoginRequestModel {
  LoginRequestModel({
    this.email,
    this.password,
  });

  late final String? email;
  late final String? password;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = email;
    _data['password'] = password;
    return _data;
  }
}
