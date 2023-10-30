import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key})
      : super(
    key: key,
    backgroundColor: Color(0xffffecda),
    elevation: 0,
    centerTitle: false,
    title: Text(
      "BeautyMinder",
      style: TextStyle(color: Color(0xffd86a04)),
    ),
    iconTheme: IconThemeData(
      color: Color(0xffd86a04),
    ),
  );
}
