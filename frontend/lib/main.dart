import 'package:beautyminder/Observer.dart';
import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

// Widget _defaultHome = WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();
  // Get result of the login function.
  // bool _result = await SharedService.isLoggedIn();
  // if (_result) {
  //   _defaultHome = const HomePage();
  // }
  //
  // setupAuthClient();

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
        '/recommend': (context) =>  const RecPage_copy(),
        '/pouch': (context) => const PouchPage(),
        // '/home': (context) => const HomePage(),
        '/todo': (context) => const TodoPage(),
        '/my': (context) => const MyPage(),

      },
    );
  }
}