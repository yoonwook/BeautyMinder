import 'package:beautyminder/Bloc/RecommendPageBloc.dart';
import 'package:beautyminder/State/RecommendState.dart';
import 'package:beautyminder/event/RecommendPageEvent.dart';
import 'package:beautyminder/pages/CosmeticDetail_Page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_error_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'home_page.dart';
import 'my_page.dart';

class RecPage extends StatefulWidget {
  const RecPage({Key? key}) : super(key: key);

  @override
  _RecPageState createState() => _RecPageState();
}

class _RecPageState extends State<RecPage> {

  int _currentIndex = 1;

  String result = '';

  bool isAll = true;
  bool isSkinCare = false;
  bool isSunCare =false;
  bool isCleanSing = false;
  bool isMaskPack = false;
  bool isBase =false;
  bool isBody =false;
  bool isHair = false;
  late List<bool> isSelected;

  @override
  void initState(){
    isSelected = [isAll, isSkinCare,  isCleanSing, isMaskPack,isSunCare,  isBase, isBody, isHair];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
            RecommendPageBloc()..add(RecommendPageInitEvent())),
        ] ,
        child: BlocListener<RecommendPageBloc, RecommendState>(
          listener: (context, state) {
           // print("state : ${state}");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                    value: context.read<RecommendPageBloc>(),
                    child: const RecErrorPage())));
          },
            listenWhen: (previous, current) {
              if (!previous.isError) {
                //print( " previous : ${previous.recCosmetics}");
                //print("previous : ${previous}" );
                return current.isError;
              } else {
                return false;
              }
            },
          child: Scaffold(
            body: Column(
              children: [
                Flexible(child: Scaffold(
                  appBar: CommonAppBar(),
                  body:  Column(
                    children: [
                      ToggleButtons(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('전체',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('스킨케어',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('클렌징',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('마스크 팩',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('썬케어',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('베이스',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('바디',style: TextStyle(fontSize: 18))),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('헤어',style: TextStyle(fontSize: 18))),

                        ], isSelected:isSelected,
                        onPressed: toggleSelect,
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: 10, // 여기서는 10개의 항목을 생성하도록 설정했습니다.
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text("추천 화장품"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CosmeticPage()));
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();  // 여기서 Divider 위젯은 아이템들 사이에 수평선을 그립니다.
                          },
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
                        else if (index == 2) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                        }
                        else if (index == 3) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
                        }
                        else if (index == 4) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyPage()));
                        }
                      }

                  ),
                ))


              ],
          ),
          )
        )
    );

  }

  void toggleSelect(int value){
    // 모든 상태를 false로 초기화합니다.
    isAll = false;
    isSkinCare = false;
    isSunCare = false;
    isCleanSing = false;
    isMaskPack = false;
    isBase = false;
    isBody = false;
    isHair = false;

    // 선택된 버튼의 인덱스에 따라 해당 상태를 true로 설정합니다.
    switch(value){
      case 0:
        isAll = true;
        break;
      case 1:
        isSkinCare = true;
        break;
      case 2:
        isCleanSing = true;
        break;
      case 3:
        isMaskPack = true;
        break;
      case 4:
        isSunCare = true;
        break;
      case 5:
        isBase = true;
        break;
      case 6:
        isBody = true;
        break;
      case 7:
        isHair = true;
        break;
    }

    // UI를 업데이트하기 위해 상태를 변경합니다.
    setState(() {
      isSelected = [isAll, isSkinCare,  isCleanSing, isMaskPack,isSunCare,  isBase, isBody, isHair];
    });
  }
}

