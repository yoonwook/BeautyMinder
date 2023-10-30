import 'dart:convert';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:beautyminder/widget/searchAppBar.dart';
import 'package:flutter/material.dart';
import '../dto/user_model.dart';
import '../services/shared_service.dart';
import '../services/todo_service.dart';
import '../dto/todo_model.dart';
import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'my_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 2;

  late Future<Result<List<Todo>>> futureTodoList;

  @override
  void initState() {
    super.initState();
    futureTodoList = TodoService.getAllTodos();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   title: const Text('beautyMinder'),
  //     //   elevation: 0,
  //     //   actions: [
  //     //     IconButton(
  //     //       icon: const Icon(
  //     //         Icons.logout,
  //     //         color: Colors.black,
  //     //       ),
  //     //       onPressed: () => SharedService.logout(context),
  //     //     ),
  //     //     const SizedBox(
  //     //       width: 10,
  //     //     ),
  //     //   ],
  //     // ),
  //     backgroundColor: Colors.grey[200],
  //     body: userProfile(),
  //     floatingActionButton: FloatingActionButton(
  //       child: const Icon(Icons.add),
  //       onPressed: () async {
  //         // final User? user = await SharedService.getUser();
  //         // if (user == null) {
  //         //   // Navigate to login or show an error.
  //         //   return;
  //         // }
  //
  //         // Here, add logic to show a dialog and add a new ToDo.
  //         // For now, let's simulate adding a new ToDo
  //         final newTodo = Todo(
  //           date: DateTime.now(),
  //           morningTasks: ['Morning task'],
  //           dinnerTasks: ['Dinner task'],
  //           user: (await SharedService.getUser())!,
  //         );
  //
  //         final result = await TodoService.addTodo(newTodo);
  //
  //         if (result.value != null) {
  //           setState(() {
  //             futureTodoList = TodoService.getAllTodos();
  //           });
  //         }
  //       },
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 100, // 1번 버튼의 높이
            width: double.infinity, // 가로로 화면을 꽉 채우도록 설정
            //1st Button - 유효기한
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PouchPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffffb876), // 버튼의 배경색
              ),
              child: Text(
                '유효기한 임박 화장품',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Container(
            height: 200, // 2번 버튼의 높이
            child: Row(
              children: [
                //2nd Button - 추천
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffffb876), // 버튼의 배경색
                    ),
                    child: Text(
                      '추천 리스트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          //3rd Button - 바우만
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PouchPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffffb876), // 버튼의 배경색
                          ),
                          child: Text(
                            '내 피부 타입',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        //4th Button - 퍼스널 컬러
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PouchPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffffb876), // 버튼의 배경색
                          ),
                          child: Text(
                            '내 퍼스널 컬러',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 100, // 5번 버튼의 높이
            width: double.infinity, // 가로로 화면을 꽉 채우도록 설정
            //5th Button - 투두 리스트
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffffb876), // 버튼의 배경색
              ),
              child: Text(
                'TODO 리스트',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // 페이지 전환 로직 추가
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage()));
          }
          else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PouchPage()));
          }
          // else if (index == 2) {
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          // }
          else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
          }
          else if (index == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyPage()));
          }
        }

      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () async {
      //     // ...
      //   },
      // ),
    );
  }





  // Widget userProfile() {
  //   return FutureBuilder(
  //     future: futureTodoList,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<Result<List<Todo>>> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //
  //       if (snapshot.hasError) {
  //         return Center(
  //           child: Text("Error: ${snapshot.error}"),
  //         );
  //       }
  //
  //       final todosResult = snapshot.data;
  //
  //       if (todosResult == null || todosResult.value == null) {
  //         return Center(
  //           child: Text(
  //               "Failed to load todos: ${todosResult?.error ?? 'Unknown error'}"),
  //         );
  //       }
  //
  //       final todos = todosResult.value!;
  //
  //       return ListView.builder(
  //         itemCount: todos.length,
  //         itemBuilder: (context, index) {
  //           final todo = todos[index];
  //           return ListTile(
  //             title: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Date: ${todo.date.toString()}"),
  //                 Text("Morning Tasks: ${todo.morningTasks.join(', ')}"),
  //                 Text("Dinner Tasks: ${todo.dinnerTasks.join(', ')}"),
  //               ],
  //             ),
  //             trailing: IconButton(
  //               icon: const Icon(Icons.delete),
  //               onPressed: () async {
  //                 final result = await TodoService.deleteTodo(todo.id ?? '-1');
  //                 if (result.value != null) {
  //                   setState(() {
  //                     futureTodoList = TodoService.getAllTodos();
  //                   });
  //                 }
  //               },
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}


// class CustomButton extends StatelessWidget {
//   final String buttonText;
//   final Widget pageRoute;
//   final Color buttonColor;
//
//   CustomButton({
//     required this.buttonText,
//     required this.pageRoute,
//     required this.buttonColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => pageRoute));
//       },
//       child: Text(buttonText),
//     );
//   }
// }