import 'dart:convert';

import 'package:beautyminder/pages/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';
import '../config.dart';
import '../dto/login_request_model.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? nickname; // 별명 필드 추가

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled() {
    return idController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }


  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              onChanged: (text) {
                setState(() {});
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }


  String? accessToken;
  String? refreshToken;

  Future<void> tryLogin(String id, String password) async {
    try {
      var request_body = jsonEncode(
          {
            "id" : "${id}",
            "password" : "${password}"
          });
      print(request_body);
      // final Map<String, String> loginData = {
      //   'userid' : id,
      //   'password' : password,
      // };
      final response = await http.post(
        Uri.parse("http://118.34.170.132:8080/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request_body,
        // body: jsonEncode(loginData),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 저장된 토큰값을 업데이트
        setState(() {
          accessToken = responseData['accessToken'];
          refreshToken = responseData['refreshToken'];
        });

        // 이후 요청에 대해 헤더에 JWT 토큰을 추가하여 보낼 수 있음
      }
      else {
        print("Login failed");
      }
      // if (response.statusCode != 201) {
      //   throw Exception("Failed to send data");
      // } else {
      //   print("User Data sent successfully");
      //   Get.to(const HomePage());
      // }
    } catch (e) {
      print("Failed to send post data: ${e}");
    }
  }



  Widget _submitButton() {
    return InkWell(
      onTap: isButtonEnabled() ? () {
        // print(idController.text);
        // print(passwordController.text);
        tryLogin(idController.text, passwordController.text);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      } : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: isButtonEnabled() ? Color(0xfffe9738) : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          '로그인',
          style: TextStyle(
            fontSize: 20,
            color: isButtonEnabled() ? Color(0xfffe9738) : Colors.grey,
          ),
        ),
      ),
    );
  }


  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }




  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '등록된 계정이 없으신가요 ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '가입하기',
              style: TextStyle(
                  color: Color(0xffffb876),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }




  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("이메일 입력", idController),
        _entryField("비밀번호 입력", passwordController, isPassword: true),
      ],
    );
  }



  // 로그인 UI
  // Widget _loginUI(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         _buildHeader(), // 헤더 구성
  //         _buildEmailField(), // 이메일 필드
  //         _buildPasswordField(), // 비밀번호 필드
  //         _buildForgetPassword(), // 비밀번호 찾기
  //         _buildLoginButton(), // 로그인 버튼
  //         _buildOrText(), // OR 텍스트
  //         _buildSignupText(), // 회원가입 텍스트
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildHeader() {
  //   return const Padding(
  //     padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
  //     child: Text(
  //       "Login",
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 25,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  // // 이메일 필드
  // Widget _buildEmailField() {
  //   return FormHelper.inputFieldWidget(
  //     context,
  //     "email",
  //     "Email",
  //     (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
  //     (val) => email = val,
  //     obscureText: false,
  //     textColor: Colors.white,
  //     hintColor: Colors.white.withOpacity(0.7),
  //     prefixIcon: const Icon(Icons.person),
  //   );
  // }

  // // 비밀번호 필드
  // Widget _buildPasswordField() {
  //   return FormHelper.inputFieldWidget(
  //     context,
  //     "password",
  //     "Password",
  //     (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
  //     (val) => password = val,
  //     obscureText: hidePassword,
  //     textColor: Colors.white,
  //     hintColor: Colors.white.withOpacity(0.7),
  //     prefixIcon: const Icon(Icons.lock),
  //     suffixIcon: IconButton(
  //       onPressed: () {
  //         setState(() {
  //           hidePassword = !hidePassword;
  //         });
  //       },
  //       color: Colors.white.withOpacity(0.7),
  //       icon: Icon(
  //         hidePassword ? Icons.visibility_off : Icons.visibility,
  //       ),
  //     ),
  //   );
  // }

  // // 비밀번호 찾기
  // Widget _buildForgetPassword() {
  //   return Align(
  //     alignment: Alignment.bottomRight,
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 25),
  //       child: RichText(
  //         text: TextSpan(
  //           style: const TextStyle(color: Colors.grey, fontSize: 14.0),
  //           children: <TextSpan>[
  //             TextSpan(
  //               text: 'Forget Password ?',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 decoration: TextDecoration.underline,
  //               ),
  //               recognizer: TapGestureRecognizer()..onTap = () {},
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // // 로그인 버튼
  // Widget _buildLoginButton() {
  //   return Center(
  //     child: FormHelper.submitButton("Login", () async {
  //       if (validateAndSave()) {
  //         setState(() {
  //           isApiCallProcess = true;
  //         });
  //         try {
  //           // 로그인 API 호출
  //           final model = LoginRequestModel(email: email, password: password);
  //           final result = await APIService.login(model);
  //
  //           if (result.value == true) {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, '/home', (route) => false);
  //           } else {
  //             // 에러 토스트 메시지
  //             Fluttertoast.showToast(
  //               msg: result.error ?? "Login Failed",
  //               toastLength: Toast.LENGTH_SHORT,
  //               gravity: ToastGravity.BOTTOM,
  //             );
  //           }
  //         } finally {
  //           setState(() {
  //             isApiCallProcess = false;
  //           });
  //         }
  //       }
  //     }),
  //   );
  // }

  // // OR 텍스트
  // Widget _buildOrText() {
  //   return const Center(
  //     child: Text(
  //       "OR",
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 18,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  // // 회원가입 텍스트
  // Widget _buildSignupText() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 25),
  //       child: RichText(
  //         text: TextSpan(
  //           style: const TextStyle(color: Colors.white, fontSize: 14.0),
  //           children: <TextSpan>[
  //             const TextSpan(text: 'Don\'t have an account? '),
  //             TextSpan(
  //               text: 'Sign up',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               recognizer: TapGestureRecognizer()
  //                 ..onTap = () {
  //                   Navigator.pushNamed(context, '/register');
  //                 },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // 입력 유효성 검사
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Color(0xffffecda),
              elevation: 0,
              centerTitle: false,
              title: Text(
                "BeautyMinder 로그인",
                style: TextStyle(color: Color(0xffd86a04)),
              ),
              iconTheme: IconThemeData(
                color: Color(0xffd86a04),
              ),
            )

        ),
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: SingleChildScrollView(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         // SizedBox(height: height * .2),
              //         // // _title(),
              //         // SizedBox(height: 50),
              //         // _emailPasswordWidget(),
              //         // SizedBox(height: 20),
              //         // _submitButton(),
              //         // Container(
              //         //   padding: EdgeInsets.symmetric(vertical: 10),
              //         //   alignment: Alignment.centerRight,
              //         //   // child: Text('Forgot Password ?',
              //         //   //     style: TextStyle(
              //         //   //         fontSize: 14, fontWeight: FontWeight.w500)),
              //         // ),
              //         // _divider(),
              //         // // _facebookButton(),
              //         // SizedBox(height: height * .055),
              //         // _createAccountLabel(),
              //       ],
              //     ),
              //   ),
              // ),

              Positioned.fill(
                child: ProgressHUD(
                  child: Form(
                    key: globalFormKey,
                    // child: _loginUI(context), /* 수정 */
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: height * .2),
                                // _title(),
                                SizedBox(height: 50),
                                _emailPasswordWidget(),
                                SizedBox(height: 20),
                                _submitButton(),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.centerRight,
                                  // child: Text('Forgot Password ?',
                                  //     style: TextStyle(
                                  //         fontSize: 14, fontWeight: FontWeight.w500)),
                                ),
                                _divider(),
                                // _facebookButton(),
                                SizedBox(height: height * .055),
                                _createAccountLabel(),
                              ],
                            ),
                          ),
                        ),
                        // _entryField("이메일 입력", idController),
                        // _entryField("비밀번호 입력", passwordController, isPassword: true),
                        // _emailPasswordWidget(),

                      ],
                    ),
                  ),
                  inAsyncCall: isApiCallProcess,
                  opacity: 0.3,
                  key: UniqueKey(),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));


    // return SafeArea(
    //   child: Scaffold(
    //     backgroundColor: HexColor("#283B71"),
    //     body: ProgressHUD(
    //       child: Form(
    //         key: globalFormKey,
    //         child: _loginUI(context),
    //       ),
    //       inAsyncCall: isApiCallProcess,
    //       opacity: 0.3,
    //       key: UniqueKey(),
    //     ),
    //   ),
    // );
  }

}
