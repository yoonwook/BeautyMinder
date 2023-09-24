import 'package:flutter/material.dart';
import 'package:capstone_design_fl/src/signup.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled() {
    return
        idController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
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

  // Widget _submitButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.symmetric(vertical: 15),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(5)),
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: Colors.grey.shade200,
  //               offset: Offset(2, 4),
  //               blurRadius: 5,
  //               spreadRadius: 2)
  //         ],
  //         gradient: LinearGradient(
  //             begin: Alignment.centerLeft,
  //             end: Alignment.centerRight,//FE9738
  //             colors: [Color(0xfffe9738), Color(0xfffe9738)])),
  //     child: Text(
  //       '로그인',
  //       style: TextStyle(fontSize: 20, color: Colors.white),
  //     ),
  //   );
  // }
  Future<String> tryLogin(String id, String password) async {
    try {
      var request_body = '''
      [
        {"id" : ${id}},
        {"password" : ${password}}
      ]
      ''';
      print(request_body);
      final response = await http.post(
        Uri.parse("/user/login"),
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
    return "login check";
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

  // Widget _facebookButton() {
  //   return Container(
  //     height: 50,
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff1959a9),
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(5),
  //                   topLeft: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('f',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 25,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 5,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff2872ba),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(5),
  //                   topRight: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('Log in with Facebook',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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

  // Widget _title() {
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //         text: 'B',
  //         style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.w700,
  //             color: Color(0xffffb876)
  //         ),
  //         children: [
  //           TextSpan(
  //             text: 'eauty',
  //             style: TextStyle(color: Colors.black, fontSize: 30),
  //           ),
  //           TextSpan(
  //             text: 'Minder',
  //             style: TextStyle(color: Color(0xffffb876), fontSize: 30),
  //           ),
  //         ]),
  //   );
  // }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
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
                  "BeautyMinder 로그인",
                  style: TextStyle(color: Color(0xffd86a04)),
                )
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
                      SizedBox(height: height * .2),
                      // _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      _divider(),
                      // _facebookButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}