import 'package:beautyminder/pages/search/search_page.dart';
import 'package:flutter/material.dart';

import '../pages/search/search_result_page.dart';

class SearchAppBar extends AppBar {
  final Widget title;
  SearchAppBar({Key? key, required this.title})
      :super(
    key: key,
    backgroundColor: Color(0xffffecda),
    elevation: 0,
    centerTitle: false,
    title: title,
    iconTheme: IconThemeData(
      color: Color(0xffd86a04),
    ),
  );
}
