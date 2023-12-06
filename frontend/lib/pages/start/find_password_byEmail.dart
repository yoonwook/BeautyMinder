import 'package:beautyminder/pages/home/home_page.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:beautyminder/widget/loginAppBar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../dto/login_request_model.dart';
import '../../services/api_service.dart';

class FindPasswordByEmailPage extends StatefulWidget {
  const FindPasswordByEmailPage({Key? key}) : super(key: key);

  @override
  _FindPasswordByEmailPageState createState() => _FindPasswordByEmailPageState();
}

class _FindPasswordByEmailPageState extends State<FindPasswordByEmailPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Colors.white,
      body: Text('비밀번호를 잊으셨나요? 이메일로 비밀번호 찾기'),
    );
  }

}
