import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'home_page.dart';
import 'my_page.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({Key? key}) : super(key: key);

  @override
  _TodoAddPage createState() => _TodoAddPage();
}

class _TodoAddPage extends State<TodoAddPage> {
  int _currentIndex = 3;
  late List<TextEditingController> _controllers = []; //

  @override
  void initState() {
    // 모든 controller을 dispose
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _controllers.forEach((controller){
      controller.dispose();
    });
    super.dispose();
  }


  void _addNewTextField(){
    setState(() {
      // 새로운 TextEditingContrller을 추가
      _controllers.add(TextEditingController());
    });
  }

  Future<void> _selectDate(BuildContext context) async{
    // Date를 저장하는 함수
    final DateTime?  picked =await showDatePicker(
    context : context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Column(
        children: [
          ..._controllers.asMap().entries.map((entry) {
            int index = entry.key;
            TextEditingController controller = entry.value;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Todo $index',
                  hintText: 'Enter Todo $index',
                  icon : Icon(Icons.today),
                  border: OutlineInputBorder(),

                ),
              ),
            );
          }).toList(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              style:  FilledButton.styleFrom(
                backgroundColor: Colors.grey
                //Color(0xffffecda),
              ),
              onPressed: _addNewTextField,
              child: Icon(Icons.add),

            ),
          ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                   //  controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Date',
                      icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber,
                            width: 1.0,
                          )),
                      contentPadding: EdgeInsets.all(3),
                    ),
                  ))
        ],
      )
      ,bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            // 페이지 전환 로직 추가
            if (index == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RecPage()));
            } else if (index == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PouchPage()));
            } else if (index == 2) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else if (index == 3) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TodoPage()));
            } else if (index == 4) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPage()));
            }
          }),
     );}
}
