import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/login/login_bloc.dart';
import '/bloc/login/login_state.dart';
import '/dto/login_request_model.dart';
import 'package:flutter/gestures.dart';
import '/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#283B71"),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else if (state is LoginFailure) {
              Fluttertoast.showToast(
                msg: state.error ?? "Login Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
          builder: (context, state) {
            return ProgressHUD(
              child: Form(
                key: globalFormKey,
                child: _loginUI(context),
              ),
              inAsyncCall: state is LoginLoading,
              opacity: 0.3,
              key: UniqueKey(),
            );
          },
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildEmailField(),
          _buildPasswordField(),
          _buildForgetPassword(),
          _buildLoginButton(),
          _buildOrText(),
          _buildSignupText(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
      child: Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return FormHelper.inputFieldWidget(
      context,
      "email",
      "Email",
          (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
          (val) => email = val,
      obscureText: false,
      textColor: Colors.white,
      hintColor: Colors.white.withOpacity(0.7),
      prefixIcon: const Icon(Icons.person),
    );
  }

  Widget _buildPasswordField() {
    return FormHelper.inputFieldWidget(
      context,
      "password",
      "Password",
          (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
          (val) => password = val,
      obscureText: hidePassword,
      textColor: Colors.white,
      hintColor: Colors.white.withOpacity(0.7),
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
        color: Colors.white.withOpacity(0.7),
        icon: Icon(
          hidePassword ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }

  Widget _buildForgetPassword() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 14.0),
            children: <TextSpan>[
              TextSpan(
                text: 'Forget Password ?',
                style: const TextStyle(
                  color: Colors.white,
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

  Widget _buildLoginButton() {
    return Center(
      child: FormHelper.submitButton("Login", () async {
        if (validateAndSave()) {
          setState(() {
            isApiCallProcess = true;
          });
          // Null Check 추가
          if (email != null && password != null) {
            try {
              // 로그인 API 호출
              final model = LoginRequestModel(email: email!, password: password!);  // Non-null assertion 사용
              final result = await APIService.login(model);

              if (result.value == true) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              } else {
                // 에러 토스트 메시지
                Fluttertoast.showToast(
                  msg: result.error ?? "Login Failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            } finally {
              setState(() {
                isApiCallProcess = false;
              });
            }
          } else {
            // 이메일 또는 비밀번호가 null인 경우 처리
            Fluttertoast.showToast(
              msg: "Email or Password is missing.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      }),
    );
  }


  Widget _buildOrText() {
    return const Center(
      child: Text(
        "OR",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSignupText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
            children: <TextSpan>[
              const TextSpan(text: 'Don\'t have an account? '),
              TextSpan(
                text: 'Sign up',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/register');
                  },
              ),
            ],
          ),
        ),
      ),
    );
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

