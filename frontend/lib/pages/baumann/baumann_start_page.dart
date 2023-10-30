import 'package:beautyminder/pages/baumann/baumann_test_page.dart';
import 'package:beautyminder/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class BaumannStartPage extends StatefulWidget {
  BaumannStartPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BaumannStartPageState createState() => _BaumannStartPageState();
}

class _BaumannStartPageState extends State<BaumannStartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_baumannStartUI(),
    );
  }

  Widget _baumannStartUI() {
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffffb876), Color(0xffffb876)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(),
            SizedBox(
              height: 80,
            ),
            _testStartButton(),
            SizedBox(
              height: 20,
            ),
            _testLaterButton(),
            SizedBox(
              height: 20,
            ),
            // _label()
          ],
        ),
      ),
    );
  }

  Widget _testStartButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BaumannTestPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffffb876).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          '테스트 시작하기',
          style: TextStyle(fontSize: 20, color: Color(0xffffb876)),
        ),
      ),
    );
  }

  Widget _testLaterButton() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text('테스트를 보지 않으시면 정확한 추천 결과를 얻기 어렵습니다. 추후 마이페이지에서 테스트를 할 수 있습니다.'),
              actions: <Widget>[
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context); // 팝업 닫기
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                TextButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.pop(context); // 팝업 닫기
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          '나중에 하기',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '바우만 피부',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: ' 테스트',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }
}