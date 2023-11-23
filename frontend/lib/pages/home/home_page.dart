import 'package:beautyminder/dto/keywordRank_model.dart';
import 'package:beautyminder/globalVariable/globals.dart';
import 'package:beautyminder/pages/baumann/baumann_history_page.dart';
import 'package:beautyminder/pages/baumann/baumann_result_page.dart';
import 'package:beautyminder/pages/todo/todo_page.dart';
import 'package:beautyminder/services/keywordRank_service.dart';
import 'package:beautyminder/widget/homepageAppBar.dart';
import 'package:beautyminder/widget/searchAppBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../dto/baumann_result_model.dart';
import '../../dto/cosmetic_expiry_model.dart';
import '../../dto/user_model.dart';
import '../../services/baumann_service.dart';
import '../../services/expiry_service.dart';
import '../../services/home_service.dart';
import '../../services/shared_service.dart';
import '../../services/todo_service.dart';
import '../../dto/todo_model.dart';
import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import '../baumann/baumann_test_start_page.dart';
import '../chat/chat_page.dart';
import '../my/my_page.dart';
import '../pouch/expiry_page.dart';
import '../recommend/recommend_bloc_screen.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  // final dynamic responseData;
  final User? user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  bool isApiCallProcess = false;

  // late Future<HomePageResult<User>> userInfo;

  // late Future<Result<List<Todo>>> futureTodoList;

  // @override
  // void initState() {
  //   super.initState();
  //   futureTodoList = TodoService.getAllTodos();
  // }

  @override
  Widget build(BuildContext context) {
    print("Here is Home Page : ${widget.user?.id}");
    print("Here is Home Page : ${widget.user}");

    return Scaffold(
      appBar: HomepageAppBar(actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            // 이미 API 호출이 진행 중인지 확인
            if (isApiCallProcess) {
              return;
            }
            // API 호출 중임을 표시
            setState(() {
              isApiCallProcess = true;
            });
            try {
              final result = await KeywordRankService.getKeywordRank();
              final result2 = await KeywordRankService.getProductRank();

              print('fdsfd keyword rank : ${result.value}');
              print('dkdkd product rank : ${result2.value}');

              if (result.isSuccess) {
                // SearchPage로 이동하고 가져온 데이터를 전달합니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      data: result.value!,
                      data2: result2.value!,
                    ),
                  ),
                );
              } else {
                // API 호출 실패를 처리합니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                      data: null,
                      data2: null,
                    ),
                  ),
                );
              }
            } catch (e) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(data: null, data2: null),
                ),
              );
            } finally {
              // API 호출 상태를 초기화합니다.
              setState(() {
                isApiCallProcess = false;
              });
            }
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: _homePageUI(),
      ),
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
          SizedBox(height: 40,),
          _invalidProjectBtn(),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              _recommendProductBtn(),
              SizedBox(width: 30,),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _personalSkinTypeBtn(),
                  SizedBox(height: 25,),
                  _chatBtn(),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          _todoListBtn(),
          // _label()
        ],
      ),
    );
  }

  Widget _invalidProjectBtn() {
    final screenWidth = MediaQuery.of(context).size.width;
    List<CosmeticExpiry> expiries = [];
    // void _loadExpiryData() async {
    //   final expiryData = await ExpiryService.getAllExpiries();
    //   setState(() {
    //     expiries = expiryData;
    //   });
    // }

    return ElevatedButton(
      onPressed: () async {
        if (isApiCallProcess) {
          return;
        }
        setState(() {
          isApiCallProcess = true;
        });
        try {
          expiries = await ExpiryService.getAllExpiries();

          print("This is Valid Button in Home Page : ${expiries}");

          if (expiries.isNotEmpty && expiries.length!=0) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CosmeticExpiryPage()));
            print("This is Valid Button in Home Page2 : ${expiries}");
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CosmeticExpiryPage()));
            print("This is Valid Button in Home Page3 : ${expiries}");
          }
        } catch (e) {
          // Handle the error case
          print('An error occurred: $e');
        } finally {
          // API 호출 상태를 초기화합니다.
          setState(() {
            isApiCallProcess = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffb876),
        // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Colors.white,
        // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0,
        // 그림자 없애기
        minimumSize: Size(screenWidth, 200.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        // child: Text("유통기한 임박 화장품"),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "유통기한 임박 화장품 ",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    // Add any other styling properties as needed
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text((expiries.length !=0) ? "등록된 화장품이 있습니다" : "등록된 화장품이 없습니다.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }



  Widget _recommendProductBtn() {
    final screenWidth = MediaQuery.of(context).size.width / 2 - 40;

    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const RecPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffecda),
        // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffff820e),
        // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0,
        // 그림자 없애기
        minimumSize: Size(screenWidth, 200.0),
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
    final screenWidth = MediaQuery.of(context).size.width / 2 - 30;
    BaumResult<List<BaumannResult>> result =
        BaumResult<List<BaumannResult>>.success([]);

    return ElevatedButton(
      onPressed: () async {
        // 이미 API 호출이 진행 중인지 확인
        if (isApiCallProcess) {
          return;
        }
        // API 호출 중임을 표시
        setState(() {
          isApiCallProcess = true;
        });
        try {
          result = await BaumannService.getBaumannHistory();

          print("This is Baumann Button in Home Page : ${result.value}");

          if (result.isSuccess && result.value!.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    BaumannHistoryPage(resultData: result.value)));
            print("This is BaumannButton in HomePage2 : ${result.value}");
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BaumannStartPage()));
            print("This is Baumann Button in Home Page2 : ${result.isSuccess}");
          }
        } catch (e) {
          // Handle the error case
          print('An error occurred: $e');
        } finally {
          // API 호출 상태를 초기화합니다.
          setState(() {
            isApiCallProcess = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xfffe9738),
        // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Colors.white,
        // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0,
        // 그림자 없애기
        minimumSize: Size(screenWidth, 90.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
        // padding: EdgeInsets.zero,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "내 피부 타입 ",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    // Add any other styling properties as needed
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text((result.value != null) ? "${widget.user?.baumann}" : "테스트하기",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatBtn() {
    final screenWidth = MediaQuery.of(context).size.width / 2 - 30;

    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffffd1a6),
        // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffd86a04),
        // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0,
        // 그림자 없애기
        minimumSize: Size(screenWidth, 90.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "소통방 가기 ",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              // Add any other styling properties as needed
            ),
          ],
        ),
      ),
    );
  }

  Widget _todoListBtn() {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CalendarPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffe7e4e1),
        // 버튼의 배경색을 검정색으로 설정
        foregroundColor: Color(0xffff820e),
        // 버튼의 글씨색을 하얀색으로 설정
        elevation: 0,
        // 그림자 없애기
        minimumSize: Size(screenWidth, 200.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 더 둥글게 설정
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("오늘의 루틴"),
      ),
    );
  }

  Widget _underNavigation() {
    return CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // 페이지 전환 로직 추가
          if (index == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const RecPage()));
          }
          else if (index == 1) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CosmeticExpiryPage()));
          }
          // else if (index == 2) {
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          // }
          else if (index == 3) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CalendarPage()));
          } else if (index == 4) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const MyPage()));
          }
        });
  }
}
