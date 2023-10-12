import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'home_page.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Text('hot'),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // 페이지 전환 로직 추가
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HotPage()));
          }
          else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PouchPage()));
          }
          else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          }
          else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
          }
          else if (index == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyPage()));
          }
        }
      ),
    );
  }
}
