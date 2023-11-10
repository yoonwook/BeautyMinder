import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dto/cosmetic_model.dart';
import '../../widget/commonAppBar.dart';

class SearchResultPage extends StatefulWidget {
  final List<Cosmetic> searchResults;
  final String searchQuery;

  const SearchResultPage({Key? key, required this.searchQuery, required this.searchResults}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  @override
  Widget build(BuildContext context) {
    // 이곳에서 검색 결과를 표시하거나 처리할 수 있음
    return Scaffold(
        appBar: CommonAppBar(),
        body: _searchResultPageUI(),
        // 여기에 검색 결과를 표시하는 위젯을 추가
    );
  }

  Widget _searchResultPageUI() {
    return Container(
      child: Column(
        children: <Widget>[
          _resultText(),
          _productList(),
        ],
      )
    );
  }

  Widget _resultText() {
    return Text("검색된 결과입니다 : ${widget.searchQuery}, ${widget.searchResults.length}개의 제품");
  }

  Widget _productList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.searchResults.length,
        itemBuilder: (context, index) {
          final product = widget.searchResults[index];
          return ListTile(
            leading:(product?.images != null && product.images!.isNotEmpty)
                ? Image.network(product.images![0])
                : Container(
                    width: 55.0,
                    height: 55.0,
                    color: Colors.white,
                  ),
            title: Text(product.name), // 이름 표시
            // 다른 정보도 필요하다면 여기에 추가
          );
        },
      ),
    );
  }
}