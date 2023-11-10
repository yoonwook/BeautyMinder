import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';

import '/bloc/register/register_bloc.dart';
import '/bloc/register/register_state.dart';
import '/bloc/register/register_event.dart';


class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? nickname;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // Registration successful
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text("Registration Successful. Please login to the account"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false,
                      );
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            );
          } else if (state is RegisterFailure) {
            // Registration failed
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                backgroundColor: Color(0xffffecda),
                elevation: 0,
                centerTitle: false,
                title: Text(
                  "BeautyMinder 회원가입",
                  style: TextStyle(color: Color(0xffd86a04)),
                ),
                iconTheme: IconThemeData(
                  color: Color(0xffd86a04),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Form(
                  key: globalFormKey,
                  child: _registerUI(context),
                ),
                if (state is RegisterLoading)
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildField(
              title: "이메일 입력",
              hintText: "이메일을 입력하세요.",
              validator: (value) => value!.isEmpty ? "이메일이 입력되지 않았습니다." : null,
              onSaved: (value) => email = value,
            ),
            SizedBox(height: 30.0),
            _buildField(
              title: "비밀번호 입력",
              hintText: "비밀번호를 입력하세요.",
              obscureText: true,
              validator: (value) => value!.isEmpty ? "비밀번호가 입력되지 않았습니다." : null,
              onSaved: (value) => password = value,
            ),
            SizedBox(height: 30.0),
            _buildField(
              title: "닉네임 입력",
              hintText: "사용하실 닉네임을 입력하세요.",
              validator: (value) => value!.isEmpty ? "닉네임이 입력되지 않았습니다." : null,
              onSaved: (value) => nickname = value,
            ),
            SizedBox(height: 60.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xfffe9738)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () => _register(context),
              child: Text('등록하기', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 50),
            Center(
              child: Text(
                "OR",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14.0),
                children: <TextSpan>[
                  TextSpan(text: '이미 등록된 계정이 있으신가요? '),
                  TextSpan(
                    text: '로그인',
                    style: TextStyle(
                      color: Color(0xffd86a04),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/login');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String title,
    required String hintText,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xffd86a04)),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
          obscureText: obscureText,
        ),
      ],
    );
  }

  void _register(BuildContext context) {
    if (validateAndSave()) {
      BlocProvider.of<RegisterBloc>(context).add(
        RegisterStarted(email: email!, password: password!, nickname: nickname),
      );
    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
