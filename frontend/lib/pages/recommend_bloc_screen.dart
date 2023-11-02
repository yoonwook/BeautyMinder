import 'package:beautyminder/Bloc/RecommendPageBloc.dart';
import 'package:beautyminder/State/RecommendState.dart';
import 'package:beautyminder/event/RecommendPageEvent.dart';
import 'package:beautyminder/pages/CosmeticDetail_Page.dart';
import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/commonAppBar.dart';
import '../widget/commonBottomNavigationBar.dart';
import 'home_page.dart';
import 'my_page.dart';

class RecPage_copy extends StatefulWidget {
  const RecPage_copy({Key? key}) : super(key: key);

  @override
  _RecPage createState() => _RecPage();
}

class _RecPage extends State<RecPage_copy> {

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
    return BlocProvider(create: (_) =>
        RecommendPageBloc()..add(RecommendPageInitEvent()),
    child:Scaffold(
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
    _RecPageImageWidget()

    ],
    ),
    bottomNavigationBar: CommonBottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (int index) {
    // 페이지 전환 로직 추가
    if (index == 0) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage_copy()));
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
    ) ,);



      Scaffold(
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
          _RecPageImageWidget()

        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            // 페이지 전환 로직 추가
            if (index == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage_copy()));
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
class _RecPageImageWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocBuilder<RecommendPageBloc, RecommendState>(
        builder: (context, state) {
          if(state is RecommendInitState || state is RecommendDownloadedState){
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: GestureDetector(
                onTap: (){
                  HapticFeedback.mediumImpact();
                  context
                      .read<RecommendPageBloc>()
                      .add(RecommendPageInitEvent());
                },
                child: Icon(
                  state is RecommendLoadedState
                      ? Icons.download_done_rounded
                      :Icons.download_rounded,
                  size: 50,
                ),
              ),
            );
          }else{
            print("Container");
            return Expanded(child:  SizedBox(
              height: double.infinity,
              child: ListView.separated(
                itemCount: 10,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Column(
                      children: [
                      Row(
                        children: [
                          Container(
                          width: 100,
                          height: 100,
                          color: const Color.fromRGBO(71, 71, 71, 1),
                            child: state.recCosmetics != null && state.recCosmetics![index].images != null && state.recCosmetics![index].images!.isNotEmpty
                                ? Image.network(
                              state.recCosmetics![index].images![0],
                              fit: BoxFit.cover,
                            )
                                : Container(),
                        ),
                        Expanded(child:
                        Container(
                          height: 100,
                          color: const Color.fromRGBO(0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _textForm(state.recCosmetics![index].name),
                              _textForm(keywordsToString(state.recCosmetics![index].keywords!)),
                            ],
                          ),
                        ))],
                      ),
                        if(index + 1 == state.recCosmetics!.length)...[
                          GestureDetector(
                            onTap: (){
                              HapticFeedback.mediumImpact();
                              context
                                  .read<RecommendPageBloc>()
                                  .add(RecommendPageCategoryChangeEvent());
                            },
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child: state is RecommendPageCategoryChangeEvent
                                    ? const Center(
                                  child: CircularProgressIndicator(color: Colors.amber),
                                )
                                    :const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size : 30
                                )
                            ),
                          )
                        ]
                      ],
                    ),
                  );
                },separatorBuilder: (context, index){
                  return Divider(
                    thickness: 1,
                    color: Colors.grey,
                  );
              }
              ),
            ));
          }
        });

  }

  Padding _textForm(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 12),
      child: Text(
        content,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

String keywordsToString(List<String> keywords) {
  // 리스트의 모든 항목을 쉼표와 공백으로 구분된 하나의 문자열로 변환합니다.
  return keywords.join(', ');
}