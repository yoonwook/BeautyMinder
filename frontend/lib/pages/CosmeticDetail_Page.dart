import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'home_page.dart';
import 'my_page.dart';

class CosmeticPage extends StatefulWidget{

  final String name;

  const CosmeticPage({Key? key, required this.name}) : super(key: key);


  @override
  _CosmeticPageState createState() => _CosmeticPageState();
}

class _CosmeticPageState extends State<CosmeticPage>{

  int _currentIndex = 1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Text(widget.name),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            // 페이지 전환 로직 추가
            if (index == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RecPage()));
            }
            else if (index == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PouchPage()));
            }
            else if (index == 2) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
            else if (index == 3) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TodoPage()));
            }
            else if (index == 4) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPage()));
            }
          }

      ),
    );
  }
}