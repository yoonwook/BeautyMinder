import 'package:beautyminder/pages/search/search_page.dart';
import 'package:flutter/material.dart';

import '../pages/search/search_result_page.dart';

class SearchAppBar extends AppBar {

  SearchAppBar({Key? key, required BuildContext context})
      :super(
    key: key,
    backgroundColor: Color(0xffffecda),
    elevation: 0,
    centerTitle: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 1,
          child: TextField(
            controller: TextEditingController(),
            onSubmitted: (text) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultPage(searchQuery: text)),);
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
          onPressed: () {
            String text = TextEditingController().text; // TextField에서 입력한 텍스트 가져오기
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultPage(searchQuery: text,)),);
          },
          icon: Icon(
            Icons.search,
            color: Color(0xffd86a04),
          ),
        ),
      ],
    ),
    // title: Text(
    //   "BeautyMinder",
    //   style: TextStyle(color: Color(0xffd86a04)),
    // ),
    iconTheme: IconThemeData(
      color: Color(0xffd86a04),
    ),
  );
}
