import 'package:beautyminder/dto/todo_model.dart';
import 'package:beautyminder/notification.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/task_model.dart';
import '../services/api_service.dart';
import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'calendar_page.dart';
import 'expiry_page.dart';
import 'home_page.dart';
import 'my_page.dart';

class TodoAddPage extends StatefulWidget {
  final List<Todo>? todos;

  const TodoAddPage({Key? key, required this.todos}) : super(key: key);

  @override
  _TodoAddPage createState() => _TodoAddPage();
}

class _TodoAddPage extends State<TodoAddPage> {
  int _currentIndex = 3;
  late List<TextEditingController> _controllers = [];
  TextEditingController _dateController = TextEditingController();
  List<List<bool>> _toggleSelections = [];
  List<String> categorys = [];
  Todo? todo;
  DateTime? pickedDate;
  bool isEmptyTextField = false;
  List<String?> dates = [];

  late List<Task> tasks;
  late int hour;
  late int minute;
  late int second;
  @override
  void initState() {
    // 모든 controller을 dispose
    super.initState();
    _controllers.add(TextEditingController());
    _dateController.text = DateTime.now().toString().substring(0, 10);
    _toggleSelections.add([false, false, true]);
    pickedDate = DateTime.parse(_dateController.text);
    dates = widget.todos!.map((e) => e.date).toList();
    print("dates : ${dates}");
    print("picked: ${pickedDate}");
    // print("DateTime.now() : ${}")
    print(dates.contains(formatDate(DateTime.now())));
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd')
        .format(date); // Use DateFormat to format the date
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
      _toggleSelections.add([false, false, true]);
    });
  }

  void _removeTextField() {
    if (_controllers.length > 1) {
      setState(() {
        _controllers.removeLast();
        _toggleSelections.removeLast();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Date를 저장하는 함수
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                disabledColor: Colors.black87,
                colorScheme: const ColorScheme.light(
                    primary: Color(0xffffecda),
                    onPrimary: Color(0xffd86a04),
                    onSurface: Colors.black
                    // onSurface: Colors.black87
                    ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffffecda),
                        foregroundColor: const Color(0xffd86a04)))),
            child: child!,
          );
        });
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              // Apply similar theme settings as DatePicker
              colorScheme: const ColorScheme.light(
                primary: Color(0xffd86a04),
                onPrimary: Colors.black87,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffffecda),
                  foregroundColor: const Color(0xffd86a04),
                ),
              ),
              // Additional theme settings for TimePicker can go here
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          // 날짜와 시간을 결합하여 _dateController에 설정합니다.
          DateTime finalDateTime = DateTime(
            pickedDate!.year,
            pickedDate!.month,
            pickedDate!.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          hour = pickedTime.hour;
          minute = pickedTime.minute;
          _dateController.text =
              DateFormat('yyyy-MM-dd – HH:mm').format(finalDateTime);
        });
      }
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   // Date를 저장하는 함수
  //   picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2000),
  //       lastDate: DateTime(2101),
  //       builder: (context, child) {
  //         return Theme(
  //           data: Theme.of(context).copyWith(
  //               disabledColor: Colors.black87,
  //               colorScheme: const ColorScheme.light(
  //                   primary: Color(0xffffecda),
  //                   onPrimary: Colors.black87,
  //                   onSurface: Colors.black
  //                   // onSurface: Colors.black87
  //                   ),
  //               textButtonTheme: TextButtonThemeData(
  //                   style: TextButton.styleFrom(
  //                       backgroundColor: const Color(0xffffecda),
  //                       foregroundColor: const Color(0xffd86a04)))),
  //           child: child!,
  //         );
  //       });
  //   if (picked != null && picked != DateTime.now()) {
  //     setState(() {
  //       _dateController.text =
  //           picked.toString().substring(0, 10); // 선택된 날짜를 TextField에 반영
  //       print(picked);
  //       print(dates.contains(formatDate(picked!)));
  //     });
  //   }
  // }

  List<Task> createTasks() {
    tasks = List.generate(_controllers.length, (index) {
      String description = _controllers[index].text;
      String category = getCategory(_toggleSelections[index]);
      return Task(category: category, description: description, done: false);
    });

    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].description.isEmpty) {
        tasks.removeAt(i);
      }
    }

    return tasks.length < 1 ? [] : tasks;
  }

  Todo? createRoutine() {
    createTasks();
    print("_dateController.text : ${_dateController.text}");
    print("picekd : $pickedDate");
    todo = Todo(date: formatDate(pickedDate!), tasks: tasks);
    print("todo :${todo.toString()}");
    return todo;
  }

  String getCategory(List<bool> categorys) {
    if (categorys[0]) {
      return "dinner";
    } else if (categorys[1]) {
      return "morning";
    } else {
      return "other";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    createRoutine();
                    if (tasks.length == 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CalendarPage()));
                    } else if (tasks.length > 0 &&
                        dates.contains(formatDate(pickedDate!))) {
                      Todo? existing_todo = widget.todos!.firstWhere(
                        (todo) =>
                            todo.date ==
                            formatDate(
                                pickedDate!), // Provide a default value (null) if no match is found
                      );
                      await TodoService.taskAddInTodo(existing_todo, tasks);
                      print("_dateController.text : ${_dateController.text}");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CalendarPage()));
                    } else {
                      print("addtodo 실행");
                      print("todo : ${todo}");
                      print("_dateController.text : ${_dateController.text}");
                      // FlutterLocalNotification.showNotification_time(
                      //     "안녕",
                      //     "하세요",
                      //     FlutterLocalNotification.makeDate(hour, minute, 00));
                      await TodoService.addTodo(todo!);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CalendarPage()));
                    }
                  },
                  icon: const Icon(Icons.add_box_rounded,
                      size: 50, color: Color(0xffd86a04)),
                  label: const Text("완료",
                      style: TextStyle(fontSize: 25, color: Color(0xffd86a04))),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => {
                    _selectDate(context),
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                          prefixStyle: TextStyle(color: Color(0xffd86a04)),
                          labelText: 'Date',
                          hintText: 'Date',
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Color(0xffd86a04),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0)),
                          contentPadding: EdgeInsets.all(3)),
                    ),
                  ),
                )),
            ..._controllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              labelText: 'Todo $index',
                              hintText: 'Enter Todo $index',
                              icon: const Icon(Icons.add_task_sharp,
                                  color: Color(0xffd86a04)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ToggleButtons(
                        isSelected: _toggleSelections[index],
                        onPressed: (int buttonIndex) {
                          setState(() {
                            if (!_toggleSelections[index][buttonIndex]) {
                              for (int i = 0;
                                  i < _toggleSelections[index].length;
                                  i++) {
                                _toggleSelections[index][i] = i == buttonIndex;
                              }
                            }
                          });
                        },
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: const Color(0xffffecda),
                        borderColor: Colors.grey,
                        selectedBorderColor: const Color(0xffffecda),
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Dinner',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Morning',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Other',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
            }).toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xffffecda)),
                    onPressed: _addNewTextField,
                    child: const Icon(Icons.add, color: Color(0xffd86a04)),
                  ),
                ),
                if (_controllers.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: ElevatedButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xffffecda)
                          //Color(0xffffecda),
                          ),
                      onPressed: _removeTextField,
                      child: const Icon(
                        Icons.remove,
                        color: Color(0xffd86a04),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) async {
            // 페이지 전환 로직 추가
            if (index == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RecPage()));
            } else if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CosmeticExpiryPage()));
            } else if (index == 2) {
              final userProfileResult = await APIService.getUserProfile();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      HomePage(/*user: userProfileResult.value!*/)));
            } else if (index == 4) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPage()));
            }
          }),
    );
  }
}
