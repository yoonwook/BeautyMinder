import 'package:beautyminder/Observer.dart';
import 'package:beautyminder/pages/Todo_Add_Page.dart';
import 'package:beautyminder/pages/my_page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';

import 'Bloc/TodoPageBloc.dart';
import 'State/TodoState.dart';
import 'dto/task_model.dart';
import 'dto/todo_model.dart';
import 'dto/user_model.dart';
import 'event/TodoPageEvent.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

// Widget _defaultHome = WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();

  final TodoService todoService = TodoService();

    // 첫 번째 Task 객체 생성
    Task tas1 = Task(
      taskId: 'task_001',
      category: 'morning',
      description: '캡디테스트입니다.',
      done: false,
    );


    List<Task> tasks = [tas1];

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

    Todo todo = Todo(
      id :'ddaa11',
      user: user,
      date: DateTime.now(),
      tasks: tasks,
      createdAt: DateTime.now()
    );


  // TodoPageBloc을 생성하고 초기화 이벤트를 추가합니다.
  final TodoPageBloc todoBloc = TodoPageBloc(todoService: todoService);

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

  Map<String, dynamic> k = {
    'name' : 'heesnag'
  };

  //final result = await TodoService.getAllTodos();
  //final result = await TodoService.addTodo(todo);
  //final result = await TodoService.deleteTodo("sss");
  //final result = await TodoService.taskUpdateTodo(k);


  //print(result.value);



  //runApp(const MyApp());

  runApp(MaterialApp(home:TodoAddPage()));

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