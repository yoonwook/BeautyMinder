import 'package:beautyminder/State/TodoState.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Bloc/TodoPageBloc.dart';
import '../dto/task_model.dart';
import '../dto/todo_model.dart';
import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'Todo_Add_Page.dart';
import 'home_page.dart';
import 'my_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _currentIndex = 3;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoPageBloc()..add(TodoPageInitEvent()),
      child: Scaffold(
          appBar: AppBar(title: Text("Todo Page")),
          //CommonAppBar()
          body: Column(
            children: [Expanded(child: todoList())],
          ),
          bottomNavigationBar: CommonBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                // 페이지 전환 로직 추가
                if (index == 0) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RecPage()));
                } else if (index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PouchPage()));
                } else if (index == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                } else if (index == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TodoPage()));
                } else if (index == 4) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyPage()));
                }
              })),
    );
  }
}

class todoList extends StatefulWidget {
  @override
  _todoList createState() => _todoList();
}

class _todoList extends State<todoList> {
  Map<String, List<Task>> grouptedTasks = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void didChangeDepedencies() {
    super.didChangeDependencies();
    groupTasksByCategory();
  }

  void groupTasksByCategory() {
    final state = context.read<TodoPageBloc>().state;
    if (state is TodoLoadedState) {
      for (var task in state.todos![0].tasks) {
        grouptedTasks.putIfAbsent(task.category, () => []).add(task);
      }
    }
  }

  Widget _buildTableCalendar(List<Todo>? todos) {

    List<dynamic> _getTodosForDay(DateTime day) {
      return todos
          ?.where((todo) => isSameDay(todo.createdAt, day))
          .toList() ?? [];
    }

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      eventLoader:_getTodosForDay ,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      // Add additional properties and methods as needed
      // For example, eventLoader or calendarBuilders for marking dates
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoPageBloc, TodoState>(builder: (context, state) {
      if (state is TodoInitState || state is TodoDownloadedState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: GestureDetector(
            child: SpinKitThreeInOut(
              color: Color(0xffd86a04),
              size: 50.0,
              duration: Duration(seconds: 2),
            ),
          ),
        );
      } else if (state is TodoLoadedState) {
        List<taskAndCategoryTitle> TaskList = [
          taskAndCategoryTitle(categoryTitle: 'Morning'),
          ...?state.todos?[0].tasks
              .where((task) => task.category == "morning")
              .map((task) => taskAndCategoryTitle(task: task)),
          taskAndCategoryTitle(categoryTitle: 'Dinner'),
          ...?state.todos?[0].tasks
              .where((task) => task.category == "dinner")
              .map((task) => taskAndCategoryTitle(task: task)),
        ];

        List<Task> morning = state.todos![0].tasks
            .where((task) => task.category == "morning")
            .toList();
        List<Task> dinner = state.todos![0].tasks
            .where((task) => task.category == "dinner")
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableCalendar(state.todos),
            Expanded(
                child: ListView.builder(
              itemCount: TaskList.length,
              itemBuilder: (context, index) {
                final item = TaskList[index];

                if (item.isCategorTitle()) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        item.categoryTitle!,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ));
                } else if (item.task != null) {
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
                                  builder: (context) => TodoAddPage(todos: [],),
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
                              // context.read<TodoPageBloc>().add(
                              //   TodoPageDeleteEvent());
                              // )
                            },
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          item.task!.description,
                          style: TextStyle(
                              decoration: item.task!.done
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        value: item.task!.done,
                        onChanged: (bool? value) {
                          setState(() {
                            item.task!.done = value!;
                            // 필요한 경우 상태 업데이트 이벤트를 여기에 추가
                          });
                          // context.read<TodoPageBloc>().add(
                          //   // const TodoPageTaskUpdateEvent( isDone: true, todos: [])
                          //   //TodoPageInitEvent()
                          //     //TodoPageErrorEvent()
                          // );

                        },
                      ));
                }
              },
            ))
          ],
        );
      } else {
        return Text("error");
      }
    });
  }
}

class taskAndCategoryTitle {
  Task? task;
  String? categoryTitle;

  taskAndCategoryTitle({this.task, this.categoryTitle});

  bool isCategorTitle() => categoryTitle != null;
}
