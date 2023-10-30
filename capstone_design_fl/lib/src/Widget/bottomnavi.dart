import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homePage.dart';
import '../hotPage.dart';
import '../myPage.dart';
import '../pouchPage.dart';
import '../todoPage.dart';

class bottomnavi extends StatefulWidget {
  bottomnavi({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _bottomnaviState createState() => _bottomnaviState();
}

class _bottomnaviState extends State<bottomnavi>{

  int _selectedIndex = 2;

  static List<Widget> pages = <Widget>[
    HotPage(),
    PouchPage(),
    HomePage(),
    TodoPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Navigation'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: 'HOT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'POUCH',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'TODO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'MY',
          ),
        ],
      ),
    );
  }

}