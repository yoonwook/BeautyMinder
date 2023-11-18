import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import '../home/home_page.dart';
import '../my/my_page.dart';
import '../pouch/expiry_page.dart';
import '../recommend/recommend_bloc_screen.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Text('todo'),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // 페이지 전환 로직 추가
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage()));
          }
          else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CosmeticExpiryPage()));
          }
          else if (index == 2) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          }
          // else if (index == 3) {
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
          // }
          else if (index == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyPage()));
          }
        }
      ),
    );
  }
}