import 'package:beautyminder/Observer.dart';
import 'package:beautyminder/notification.dart';
import 'package:beautyminder/notification_test.dart';

import 'package:beautyminder/pages/calendar_page.dart';

import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/picture_test.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/skin_timeline.dart';
import 'package:beautyminder/pages/testPage.dart';

import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Bloc/TodoPageBloc.dart';

import 'dto/task_model.dart';
import 'dto/todo_model.dart';
import 'dto/user_model.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


// Widget _defaultHome = WelcomePage();

void _setupLogging() {
  Logger.root.level = Level.ALL; // 모든 로그 레벨 활성화
  Logger.root.onRecord.listen((record) {
    // 로그 출력 형식을 여기서 설정
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

  getPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification
  ].request();
}



void main() async {
  tz.initializeTimeZones();
  getPermission();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();
  _setupLogging();
  final TodoService todoService = TodoService();

  PermissionStatus status = await Permission.notification.status;

  if(!status.isGranted){
    Permission.notification.request();
  }

  runApp(
    MaterialApp(
        navigatorKey: FlutterLocalNotification.navigatorKey,
        title: 'BeautyMinder',
        home: //testPage(),
            //picturePage(),
            CalendarPage()),
            //timeLine()
            //notitest()),
  );
}

class MyApp extends StatelessWidget {
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
        '/recommend': (context) => const RecPage(),
        '/pouch': (context) => const PouchPage(),
        // '/home': (context) => const HomePage(),
        '/todo': (context) => const CalendarPage(),
        '/my': (context) => const MyPage(),
      },
    );
  }
}
