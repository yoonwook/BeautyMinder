import 'package:beautyminder/Bloc/TodoPageBloc.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/pages/Todo_Add_Page_Test.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:beautyminder/services/todo_service.dart';

import '../../State/TodoState.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TodoPageBloc()..add(TodoPageInitEvent()),
    child: Scaffold(
      body: Column(
        children: [
          BlocBuilder<TodoPageBloc, TodoState>(builder:
          (context, state){
            return _todoList();
              //_calendar();
          })
        ],
      ),
    ));

    // child: SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       BlocBuilder<TodoPageBloc, TodoState>(
    //       builder: (context, state) {
    //         _calendar();,
    //         _todoList()
    //       }
    //       )
    //
    //     ],
    //   ),
    // ));
    // SingleChildScrollView(
    //     child: Column(
    //   children: [
    //     _calendar(),
    //     _todoList(),
    //   ],
    // ));
  }

  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget _todoList() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: _buildChildren(),
        ));
  }

  List<Widget> _buildChildren() {
    List<Widget> _children = [];
    List<Widget> _morningTasks = [];
    List<Widget> _dinnerTasks = [];
    var todos = TodoService.getAllTodos();
    List taskList = [
      {"description": "설명", "category": "morning", "isDone": false},
      {"description": "설명2", "category": "morning", "isDone": true},
      {"description": "다같이", "category": "dinner", "isDone": false}
    ];

    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i]['category'] == 'morning') {
        _morningTasks
            .add(_todo(taskList[i]['description'], taskList[i]['isDone']));
      } else if (taskList[i]['category'] == 'dinner') {
        _dinnerTasks
            .add(_todo(taskList[i]['description'], taskList[i]['isDone']));
      }
    }

    _children.add(_row('morning'));
    _children.addAll(_morningTasks);
    _children.add(_row('dinner'));
    _children.addAll(_dinnerTasks);

    return _children;
  }

  Widget _row(String name) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _todo(String title, bool isDone) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        dragDismissible: false,
        children: [
          SlidableAction(
            label: 'Update',
            backgroundColor: Colors.orange,
            icon: Icons.archive,
            onPressed: (context) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TodoAddPage(),
                ),
              );
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        dragDismissible: false,
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) async {
              // setState(() {
              //   _selectedTodos.value.removeWhere((todo) => todo.id == Todo.id);
              // });
            },
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          value: isDone,
          onChanged: (bool? newValue) {},
        ),
        onTap: () {
          setState(() {
            isDone = !isDone;
            print(isDone);
          });
        },
      ),
    );
  }
}
