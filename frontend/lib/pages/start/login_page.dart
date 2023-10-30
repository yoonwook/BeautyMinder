import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../services/api_service.dart';
import '../../dto/login_request_model.dart';


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



  @override
  Widget build(BuildContext context) {
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
            ),
        ),
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      );
  }



  // 로그인 UI
  Widget _loginUI(BuildContext context) {
    return Container (
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          SizedBox(height: 200), // 여백 추가
          _buildEmailField(), // 이메일 필드

          SizedBox(height: 30), // 여백 추가
          _buildPasswordField(), // 비밀번호 필드

          SizedBox(height: 50), // 여백 추가
          _buildForgetPassword(), // 비밀번호 찾기

          SizedBox(height: 20), // 여백 추가
          _buildLoginButton(), // 로그인 버튼

          SizedBox(height: 50), // 여백 추가
          _buildOrText(), // OR 텍스트

          SizedBox(height: 20), // 여백 추가
          _buildSignupText(), // 회원가입 텍스트
        ],
      ),
    );
  }



  // 이메일 필드
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "이메일 입력",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
        TextFormField(
          validator: (val) => val!.isEmpty ? '이메일이 입력되지 않았습니다.' : null,
          onChanged: (val) => email = val,
          obscureText: false,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "이메일을 입력하세요",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            prefixIcon: Icon(Icons.person),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffd86a04), // 클릭 시 테두리 색상 변경
              ),
            ),
          ),
        ),
      ],
    );
  }



  // 비밀번호 필드
  Widget _buildPasswordField() {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "비밀번호 입력",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          validator: (val) => val!.isEmpty ? '비밀번호가 입력되지 않았습니다.' : null,
          onChanged: (val) => password = val,
          obscureText: hidePassword,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "비밀번호를 입력하세요",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: hidePassword ? Colors.grey.withOpacity(0.7) : Color(0xffd86a04),
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
                color: hidePassword ? Colors.grey.withOpacity(0.7) : Color(0xffd86a04),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffd86a04), // 클릭 시 테두리 색상 변경
              ),
            ),
          ),
        ),
      ],
    );
  }



  // 비밀번호 찾기
  Widget _buildForgetPassword() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
            children: <TextSpan>[
              TextSpan(
                text: 'Forget Password ?',
                style: const TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
      ),
    );
  }



  // 로그인 버튼
  Widget _buildLoginButton() {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Container(
        width: screenWidth, // 원하는 너비 설정
        height: 50, // 원하는 높이 설정
        decoration: BoxDecoration(
          color: Color(0xfffe9738), // 버튼 배경색 설정
          borderRadius: BorderRadius.circular(10.0), // 원하는 모양 설정
        ),
        child: Center(
          child: Text(
            "로그인",
            style: TextStyle(
              color: Colors.white, // 텍스트 색상 설정
              fontSize: 18, // 텍스트 크기 설정
            ),
          ),
        ),
      ),
      onTap: () async {
        if (validateAndSave()) {
          setState(() {
            isApiCallProcess = true;
          });
          try {
            // 로그인 API 호출
            final model = LoginRequestModel(email: email, password: password);
            final result = await APIService.login(model);

            if (result.value == true) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else {
              // 에러 토스트 메시지
              Fluttertoast.showToast(
                msg: result.error ?? "로그인에 실패하였습니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          } finally {
            setState(() {
              isApiCallProcess = false;
            });
          }
        }
      },
    );
  }



  // OR 텍스트
  Widget _buildOrText() {
    return const Center(
      child: Text(
        "OR",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }



  // 회원가입 텍스트
  Widget _buildSignupText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
            children: <TextSpan>[
              const TextSpan(text: '등록된 계정이 없으신가요? '),
              TextSpan(
                text: '회원 가입',
                style: const TextStyle(
                  color: Color(0xffd86a04),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/user/signup');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }



  // 입력 유효성 검사
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
