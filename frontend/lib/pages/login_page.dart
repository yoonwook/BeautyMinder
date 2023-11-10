import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/login/login_bloc.dart';
import '/bloc/login/login_state.dart';
import '/bloc/login/login_event.dart';
import '/dto/login_request_model.dart';
import 'package:flutter/gestures.dart';
import '/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // AppBar 추가
      child: Scaffold(
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
        backgroundColor: Colors.white,  // 배경색 변경
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: email,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "email",
          prefixIcon: const Icon(Icons.person),
          fillColor: Colors.white.withOpacity(0.7),
          filled: true,
        ),
        validator: (val) => val!.isEmpty ? 'Email can\'t be empty.' : null,
        onChanged: (val) => setState(() { email = val; }),
      ),
    );
  }


  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: password,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "password",
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white.withOpacity(0.7),
          filled: true,
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
        ),
        validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
        obscureText: hidePassword,
        onChanged: (val) => setState(() { password = val; }),
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

  Widget _buildLoginButton() {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Container(
        width: screenWidth,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xfffe9738),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            "로그인",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      onTap: () {
        if (validateAndSave()) {
          // 로그인 시작 이벤트 전달
          context.read<LoginBloc>().add(LoginStarted(email: email!, password: password!));
        }
      },
    );
  }

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
    return true;
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

