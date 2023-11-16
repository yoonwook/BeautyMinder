import 'package:beautyminder/Bloc/TodoPageBloc.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoUpdatePage extends StatefulWidget{
  const TodoUpdatePage({Key? key}) : super(key: key);

  @override
_TodoUpdatePage createState() => _TodoUpdatePage();
}

class _TodoUpdatePage extends State<TodoUpdatePage>{
  int _currentIndex = 3;
  TextEditingController controller = TextEditingController();


  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return BlocProvider(create: (_) => TodoPageBloc()..add(TodoPageUpdateEvent())
      ,
      child: Scaffold(
        appBar: CommonAppBar(),
        body: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Todo',
                hintText: 'Enter Todo',
                icon : Icon(Icons.add_task_sharp),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ));

  }



}