
import 'package:beautyminder/Observer.dart';

import 'package:beautyminder/pages/calendar_page.dart';

import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/picture_test.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/testPage.dart';

import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';

import 'Bloc/TodoPageBloc.dart';

import 'dto/task_model.dart';
import 'dto/todo_model.dart';
import 'dto/user_model.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:logging/logging.dart';

// Widget _defaultHome = WelcomePage();

void _setupLogging() {
  Logger.root.level = Level.ALL; // 모든 로그 레벨 활성화
  Logger.root.onRecord.listen((record) {
    // 로그 출력 형식을 여기서 설정
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();
  _setupLogging();

  final TodoService todoService = TodoService();

  // 첫 번째 Task 객체 생성
  Task tas1 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );
  Task tas2 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );
  Task tas3 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );
  Task tas4 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );
  Task tas5 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );
  Task tas6 = Task(
    taskId: 'task_001',
    category: 'morning',
    description: '캡디테스트입니다.',
    done: false,
  );

  Task tas7 = Task(
    taskId: 'task_001',
    category: 'dinner',
    description: '캡디테스트입니다. dinner',
    done: false,
  );

  Task tas8 = Task(
    taskId: 'task_001',
    category: 'dinner',
    description: '캡디테스트입니다. dinner',
    done: false,
  );

  Task tas9 = Task(
    taskId: 'task_001',
    category: 'dinner',
    description: '캡디테스트입니다. dinner',
    done: false,
  );

  List<Task> tasks = [tas1, tas2, tas3, tas4, tas5, tas6, tas7, tas8, tas9];

  User user = User(
    id: '65499d8316f366541e3cc0a2',
    email: 'user@example.com',
    password: 'securepassword123',
    nickname: 'JohnDoe',
    profileImage: 'path/to/image.jpg',
    createdAt: DateTime.now(),
    authorities: 'ROLE_USER',
    phoneNumber: '0100101',
  );

  // Todo todo = Todo(
  //     id: 'ddaa11',
  //     user: user,
  //     date: DateTime.parse('2023-08-26 00:00:00.000'),
  //     tasks: tasks,
  //     createdAt: DateTime.parse('2023-08-24 00:00:00.000'));

  // TodoPageBloc을 생성하고 초기화 이벤트를 추가합니다.
  final TodoPageBloc todoBloc = TodoPageBloc();

  // todoBloc.add(TodoPageAddEvent(todo));
  //todoBloc.add(TodoPageInitEvent());// 불러오기 까지 성공
  //todoBloc.add(TodoPageAddEvent(todo));

  // todoBloc.add(TodoPageAddEvent(todo));

  // // 초기화 이벤트를 추가합니다.
  //  todoBloc.add(TodoPageInitEvent());
  // // BlocListener 혹은 BlocConsumer를 사용하여 상태 변화를 감지합니다.
  // // 여기에서는 예시를 위해 콘솔 출력을 사용합니다.
  // todoBloc.stream.listen((state) {
  //   //print(state);
  //   if (state is TodoLoadedState) {
  //     // 이 상태가 TodoLoadedState로 변경되면 다음 이벤트를 추가합니다.
  //     print('InitEvent 처리 완료, AddEvent 추가');
  //     todoBloc.add(TodoPageAddEvent(todo));
  //   }
  // });

  Map<String, dynamic> update_todo = {
    "todoId": "65445f81f354753415c09cb4",
    "timeOfDay": "morning",
    "taskIndex": 2,
    "newTask": "string111"
  };

  //final result = await TodoService.getAllTodos();
  //final result = await TodoService.addTodo(todo);
  //final result = await TodoService.deleteTodo("sss");
  //final result = await TodoService.taskUpdateTodo(k);
  //final result = await TodoService.taskUpdateTodo();
  final result = await TodoService.getTodo();


  print("result.value : ${result.value}");

  // runApp(MultiBlocProvider(
  //     providers: [
  //       BlocProvider<RecommendPageBloc>(
  //         create: (context) => RecommendPageBloc(),
  //       ),
  //       BlocProvider<TodoPageBloc>(create: (create) => TodoPageBloc())
  //     ],
  //     child: MaterialApp(
  //       title: 'BeautyMinder',
  //       theme: ThemeData(
  //         primaryColor: const Color(0xffffb876),
  //       ),
  //       home: //MyApp()
  //       //TodoAddPage(),
  //       CalendarPage()
  //       //const TodoPage(),
  //     )
  //     //
  //     ));

  runApp(
    MaterialApp(
      title: 'BeautyMinder',
      home: //testPage(),
      //picturePage(),
      CalendarPage(),
    ),
  );

  // runApp(MaterialApp(
  //     title: 'BeautyMinder',
  //     theme: ThemeData(
  //       primaryColor: const Color(0xffffb876),
  //     ),
  //     home: //TodoPage()
  //   //TodoAddPage(),
  //   CalendarPage(),
  //   //CameraPage()
  //   )
  //
  // );
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
