import 'dart:convert';
import 'package:beautyminder/pages/baumann/baumann_result_page.dart';
import 'package:beautyminder/pages/pouch/pouch_page.dart';
import 'package:beautyminder/pages/recommend/recommend_page.dart';
import 'package:beautyminder/pages/todo/todo_page.dart';
import 'package:beautyminder/services/keywordRank_service.dart';
import 'package:beautyminder/widget/homepageAppBar.dart';
import 'package:beautyminder/widget/searchAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../dto/user_model.dart';
import '../../services/shared_service.dart';
import '../../services/todo_service.dart';
import '../../dto/todo_model.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import '../my/my_page.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 2;
  bool isApiCallProcess = false;

  // late Future<Result<List<Todo>>> futureTodoList;

  // @override
  // void initState() {
  //   super.initState();
  //   futureTodoList = TodoService.getAllTodos();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(actions: <Widget> [
        IconButton(
          icon:Icon(Icons.search),
          onPressed: () async {
            //이미 API 호출이 진행 중인지 확인
            if (isApiCallProcess) {
              return;
            }
            // API 호출 중임을 표시
            setState(() {
              isApiCallProcess = true;
            });
            try {
              final result = await KeywordRankService.getKeywordRank();
              print('keyword rank : ${result.value}');
              if (result.isSuccess) {
                // BaumannTestPage로 이동하고 가져온 데이터를 전달합니다.
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(data: result.value!),),);
              }
              else {
                // API 호출 실패를 처리합니다.
                Fluttertoast.showToast(
                  msg: result.error ?? '바우만 데이터 가져오기 실패',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              }
            }
            finally {
              // API 호출 상태를 초기화합니다.
              setState(() {
                isApiCallProcess = false;
              });
            }
          },
        ),
      ]),
      body: _homePageUI(),
      bottomNavigationBar: _underNavigation(),
    );
  }

  Widget _homePageUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _invalidProjectBtn(),
          // SizedBox(height: 50,),
          Row(
            children: <Widget>[
              _recommendProductBtn(),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _personalSkinTypeBtn(),
                  _personalColorBtn(),
                ],
              )
            ],
          ),
          _todoListBtn(),
          // _label()
        ],
      ),
    );
  }

  Widget _invalidProjectBtn() {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PouchPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffb876),  // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Colors.white, // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0, // 그림자 없애기
        minimumSize: Size(screenWidth, 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text("유통기한 임박 화장품"),
      ),

    );
  }

  Widget _recommendProductBtn() {
    final screenWidth = MediaQuery.of(context).size.width/2-20;

    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffecda), // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffff820e), // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0, // 그림자 없애기
        minimumSize: Size(screenWidth, 160.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("추천 화장품"),
      ),

    );
  }

  Widget _personalSkinTypeBtn() {
    final screenWidth = MediaQuery.of(context).size.width/2-20;

    return ElevatedButton(
      onPressed: (){
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BaumannResultPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xfffe9738), // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Colors.white, // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0, // 그림자 없애기
        minimumSize: Size(screenWidth, 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("내 피부 타입"),
      ),

    );
  }

  Widget _personalColorBtn() {
    final screenWidth = MediaQuery.of(context).size.width/2-20;

    return ElevatedButton(
      onPressed: (){
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BaumannResultPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffd1a6), // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffd86a04), // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0, // 그림자 없애기
        minimumSize: Size(screenWidth, 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("내 퍼스널 컬러"),
      ),

    );
  }

  Widget _todoListBtn() {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffe7e4e1), // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffff820e), // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0, // 그림자 없애기
        minimumSize: Size(screenWidth, 80.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("Todo 리스트"),
      ),

    );
  }

  Widget _underNavigation() {
    return CommonBottomNavigationBar(
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
    );
  }
}

