import 'package:beautyminder/dto/favorite_model.dart';
import 'package:beautyminder/services/api_service.dart';
import 'package:beautyminder/services/shared_service.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  List favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfavorites();
  }

  getfavorites() async {
    try {
      final info = await APIService.getFavorites();
      setState(() {
        favorites = info.value! as List;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  // favorite 데이터 사용법
  // 위 favorites = info; 의 주석을 제거,
  // favorites[index].brand 처럼 쓰기.
  // itemCounter는 favorites.length 로 하기.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: isLoading ? Center(child: Text('로딩 중')) : _body(),
    );
  }

  Widget _body() {
    print(favorites.first['images']);
    return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) => ListTile(
          leading: Image.network(favorites[index]['images'][0] ?? ''),
          title: Text(favorites[index]['name']),
          subtitle: Text(favorites[index]['createdAt']),
        ));
  }
}
