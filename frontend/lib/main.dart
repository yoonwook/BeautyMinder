import 'package:beautyminder/pages/my/my_page.dart';
import 'package:beautyminder/pages/pouch/pouch_page.dart';
import 'package:beautyminder/pages/recommend/recommend_page.dart';
import 'package:beautyminder/pages/start/splash_page.dart';
import 'package:beautyminder/pages/todo/todo_page.dart';
import 'package:beautyminder/pages/start/welcome_page.dart';
import 'package:flutter/material.dart';

import 'pages/home/home_page.dart';
import 'pages/start/login_page.dart';
import 'pages/start/register_page.dart';

// Widget _defaultHome = WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: WelcomePage(),
      routes: {
        // '/': (context) => _defaultHome,
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/recommend': (context) => const RecPage(),
        '/pouch': (context) => const PouchPage(),
        '/home': (context) => const HomePage(),
        '/todo': (context) => const TodoPage(),
        '/my': (context) => const MyPage(),

      },
    );
  }
}