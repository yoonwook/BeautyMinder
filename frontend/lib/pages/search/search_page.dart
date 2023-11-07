import 'package:beautyminder/dto/keywordRank_model.dart';
import 'package:beautyminder/widget/searchAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.data}) : super(key: key);

  final KeyWordRank data;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(context: context,),
      body: _searchPageUI(),
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
          return ListTile(
              title: Text('${rank}순위 : ${word}')
          );
        },
      );
    }
  }


}