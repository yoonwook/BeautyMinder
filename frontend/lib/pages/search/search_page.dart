import 'package:beautyminder/dto/keywordRank_model.dart';
import 'package:beautyminder/pages/search/search_result_page.dart';
import 'package:beautyminder/widget/searchAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/homeSearch_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.data}) : super(key: key);

  final KeyWordRank data;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = ''; // 검색어를 저장할 변수
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose(); // 필요한 경우 컨트롤러를 해제합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(title:_title()),
      body: _searchPageUI(),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 1,
          child: TextField(
            controller: textController,
            // onSubmitted: (text) {
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultPage(searchQuery: text)),);
            // },
            onChanged: (text) {
              searchQuery = text;
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 15,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10), //포커스 시
                ),
                borderSide: BorderSide(
                  color: Color(0xffd86a04),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // 활성화 상태 모서리를 둥글게 조정
                ),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintText: "검색 키워드를 입력해주세요.",
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        IconButton(
          onPressed: () async {
            try {
              final result = await SearchService.searchAnything(searchQuery);
              print(result);

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultPage(searchQuery: searchQuery, searchResults: result, )),);
              print('////////////searchQuery : $searchQuery');
              } catch (e) {
                print('Error searching anything: $e');
              }
          },
          icon: Icon(
            Icons.search,
            color: Color(0xffd86a04),
          ),
        ),
      ],
    );
  }


  Widget _searchPageUI() {
    if (widget.data.keywords == null) {
      return Center(
        child: Text('실시간 랭킹 순위가 없습니다.'),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.data.keywords?.length,
        itemBuilder: (context, index) {
          final word = widget.data.keywords![index];
          final rank = index + 1;
          return GestureDetector(
            onTap: () async {
              _navigateToSearchResultPage(word);
            },
            child: ListTile(
              title: Text('${rank}순위 : ${word}'),
            ),
          );
        },
      );
    }
  }


  void _navigateToSearchResultPage(String keyword) async {
    try {
      final result = await SearchService.searchAnything(keyword);
      print(result);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultPage(
          searchQuery: keyword,
          searchResults: result,
        ),
      ));
      print('////////////searchQuery : $searchQuery');
    } catch (e) {
      print('Error searching anything: $e');
    }
  }


}

// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패

  bool get isSuccess => value != null;
}