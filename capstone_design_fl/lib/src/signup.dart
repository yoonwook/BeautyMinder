import 'package:flutter/material.dart';
import 'package:capstone_design_fl/src/Widget/bezierContainer.dart';
import 'package:capstone_design_fl/src/loginPage.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Widget _backButton() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
  //             child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
  //           ),
  //           Text('Back',
  //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
  //         ],
  //       ),
  //     ),
  //   );
  // }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        idController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void dispose() {
    // 페이지가 dispose될 때 컨트롤러 정리
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Widget _entryField(String title, TextEditingController controller,{bool isPassword = false}) {
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
               setState(() {}); //text 변경시에 화면 다시 그림
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

  // Widget _submitButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.symmetric(vertical: 15),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       border: Border.all(color: Color(0xfffe9738), width: 2),
  //         ),
  //     child: Text(
  //       '회원가입',
  //       style: TextStyle(fontSize: 20, color: isButtonEnabled() ? Color(0xfffe9738) : Colors.grey),
  //     ),
  //   );
  // }

  Future<String> trySignUp(String name, String email,String phone, String id, String password) async {
    try {
      var request_body = '''
      [
        {"name" : ${name}},
        {"email" : ${email}},
        {"phone" : ${phone}},
        {"id" : ${id}},
        {"password" : ${password}}
      ]
      ''';
      print(request_body);
      final response = await http.post(
        Uri.parse("/user/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: request_body,
      );
      print(response.body);
      // if (response.statusCode != 201) {
      //   throw Exception("Failed to send data");
      // } else {
      //   print("User Data sent successfully");
      //   Get.to(const HomePage());
      // }
    } catch (e) {
      print("Failed to send post data: ${e}");
    }
    return "signup check";
  }

  Widget _submitButton() {
    return InkWell(
      onTap: isButtonEnabled() ? () {

        // nameController),
        // _entryField("이메일 입력", emailController),
        // _entryField("전화번호 입력", phoneController),
        // _entryField("아이디 입력", idController),
        // _entryField("비밀번호 입력", passwordController

        trySignUp(nameController.text,emailController.text,phoneController.text,idController.text,passwordController.text);

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
          '회원가입',
          style: TextStyle(
            fontSize: 20,
            color: isButtonEnabled() ? Color(0xfffe9738) : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '이미 등록된 계정이 있으신가요 ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '로그인하기',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _title() {
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //         text: 'Beauty',
  //         style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.w700,
  //             color: Color(0xffe46b10)
  //         ),
  //
  //         children: [
  //           TextSpan(
  //             text: 'Minder',
  //             style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
  //           ),
  //         ]),
  //   );
  // }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("이름 입력", nameController),
        _entryField("이메일 입력", emailController),
        _entryField("전화번호 입력", phoneController),
        _entryField("아이디 입력", idController),
        _entryField("비밀번호 입력", passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xffffecda),
          title: Text(
            "BeautyMinder 회원가입",
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(height: height * .2),
                    // _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .02),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            // Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}