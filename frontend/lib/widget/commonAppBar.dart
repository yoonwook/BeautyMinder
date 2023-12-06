import 'package:beautyminder/pages/recommend/recommend_bloc_screen.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
          key: key,
          backgroundColor: Color(0xffffecda),
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "BeautyMinder",
            style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xffd86a04),
          ),
          leading: automaticallyImplyLeading == true
              ? IconButton(
                  onPressed: () => Navigator.of(context!).pop(true),
                  icon: Icon(Icons.arrow_back_ios),
                )
              : null
        );
}

class RecCommonAppBar extends AppBar {
  RecCommonAppBar({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
    key: key,
    backgroundColor: Color(0xffffecda),
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 0,
    centerTitle: false,
    title: const Text(
      "BeautyMinder",
      style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xffd86a04),
    ),
    leading: automaticallyImplyLeading == true
        ? IconButton(
      onPressed: () => Navigator.of(context!).pop(true),
      icon: Icon(Icons.arrow_back_ios),
    )
        : null,
    // 여기에 actions 속성 추가
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          Navigator.of(context!).pushReplacement(MaterialPageRoute(
              builder: (context) => RecPage()));
        },
      ),
    ],
  );
}


