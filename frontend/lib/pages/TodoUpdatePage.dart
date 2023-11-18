import 'package:beautyminder/Bloc/TodoPageBloc.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../dto/task_model.dart';
import '../dto/todo_model.dart';

class TodoUpdatePage extends StatefulWidget {
  final String description;
  final Todo todo;
  final Task task;
  const TodoUpdatePage(this.description, this.todo, this.task, {Key? key})
      : super(key: key);

  @override
  _TodoUpdatePage createState() => _TodoUpdatePage();
}

class _TodoUpdatePage extends State<TodoUpdatePage> {
  int _currentIndex = 3;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.description;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87);

    return BlocProvider(
        create: (_) => TodoPageBloc()..add(TodoPageTaskUpdateEvent()),
        child: Scaffold(
          appBar: CommonAppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(widget.todo.createdAt!),
                  style: style,
                ),
                Row(
                  children: [
                    Expanded(child:TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Todo',
                        hintText: 'Enter Todo',
                        icon: Icon(Icons.add_task_sharp),
                        border: OutlineInputBorder(),
                      ),
                    ) ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        // 버튼 클릭 시 수행할 작업
                      },
                    )],
                ),
              ],
            ),
          ),
        ));
  }
}
