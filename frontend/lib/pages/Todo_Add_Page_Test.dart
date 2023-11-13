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
  late List<TextEditingController> _controllers = [];
  TextEditingController _dateController = TextEditingController();
  List<List<bool>> _toggleSelections = [];

  @override
  void initState() {
    // 모든 controller을 dispose
    super.initState();
    _controllers.add(TextEditingController());
    _dateController.text = DateTime.now().toString().substring(0, 10);
    _toggleSelections.add([false, false]);
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.dispose();
    });
    _dateController.dispose();
    super.dispose();
  }

  void _addNewTextField() {
    setState(() {
      // 새로운 TextEditingContrller을 추가
      _controllers.add(TextEditingController());
      _toggleSelections.add([false, false]);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    // Date를 저장하는 함수
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text =
            picked.toString().substring(0, 10); // 선택된 날짜를 TextField에 반영
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                          labelText: 'Date',
                          hintText: 'Date',
                          icon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.amber, width: 1.0)),
                          contentPadding: EdgeInsets.all(3)),
                    ),
                  ),
                )),
            ..._controllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Todo $index',
                          hintText: 'Enter Todo $index',
                          icon: Icon(Icons.add_task_sharp),
                          border: OutlineInputBorder(),
                        ),
                      ),),

                      ToggleButtons(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Dinner' ,style: TextStyle(color: Colors.black),),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Morning', style: TextStyle(color: Colors.black),),
                          ),
                        ],
                        isSelected: _toggleSelections[index],
                        onPressed: (int buttonIndex) {
                          setState(() {
                            _toggleSelections[index][buttonIndex] =
                                !_toggleSelections[index][buttonIndex];
                          });
                        },
                        color: Colors.black,
                        selectedColor: Colors.white,
                        fillColor: Color(0xffffecda),
                        borderColor: Colors.grey,
                        selectedBorderColor: Color(0xffffecda),
                      )
                    ],
                  ));
            }).toList(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.grey
                    //Color(0xffffecda),
                    ),
                onPressed: _addNewTextField,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
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
    );
  }
}
