import 'package:beautyminder/Observer.dart';
import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';

import 'dto/todo_model.dart';
import 'dto/user_model.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

// Widget _defaultHome = WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();

  User user = User(
    id: '65445f81f354753415c09cb4',
    email: 'user@example.com',
    password: 'securepassword123',
    nickname: 'JohnDoe',
    profileImage: 'path/to/image.jpg',
    createdAt: DateTime.now(),
    authorities: 'ROLE_USER',
    phoneNumber: '0100101',
  );

  // Todo todo = Todo(
  //   id: '123',
  //   date: DateTime.now(),
  //   morningTasks: ['Task 5451', 'Task 2', 'Task 3'],
  //   dinnerTasks: ['Task 4', 'Task 5', 'Task 6'],
  //   user: user,
  //   createdAt: DateTime.now(),
  // );

  Map<String, dynamic> update_todo = {
    "todoId": "65445f81f354753415c09cb4",
    "timeOfDay": "morning",
    "taskIndex": 2,
    "newTask": "string111"
  };

  Map<String, dynamic> k = {
    'name' : 'heesnag'
  };

  //final result = await TodoService.getAllTodos();
  //final result = await TodoService.addTodo();
  //final result = await TodoService.deleteTodo("sss");
  //final result = await TodoService.taskUpdateTodo(k);


  //print(result.value);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyMinder',
      theme: ThemeData(
        primaryColor: const Color(0xffffb876),
      ),
      // home: const LoginPage(),
      home: const HomePage(),
      routes: {
        // '/': (context) => _defaultHome,
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/recommend': (context) =>  const RecPage(),
        '/pouch': (context) => const PouchPage(),
        // '/home': (context) => const HomePage(),
        '/todo': (context) => const TodoPage(),
        '/my': (context) => const MyPage(),

      },
    );
  }
}