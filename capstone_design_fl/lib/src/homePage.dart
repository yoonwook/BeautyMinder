import 'package:capstone_design_fl/src/hotPage.dart';
import 'package:capstone_design_fl/src/myPage.dart';
import 'package:capstone_design_fl/src/pouchPage.dart';
import 'package:capstone_design_fl/src/todoPage.dart';
import 'package:flutter/material.dart';
import 'package:capstone_design_fl/src/loginPage.dart';
import 'package:capstone_design_fl/src/signup.dart';
import 'package:capstone_design_fl/src/Widget/bottomnavi.dart';


class HomePage extends StatefulWidget {
  HomePage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
              "BeautyMinder",
              style: TextStyle(color: Color(0xffd86a04)),
            ),
            iconTheme: IconThemeData(
              color: Color(0xffd86a04),
            ),
          ),
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
                    // _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    // _submitButton(),
                    SizedBox(height: height * .02),
                    // _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            // Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
      // bottomNavigationBar: bottomnavi(),
    );
  }
}