import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key, bool automaticallyImplyLeading = false, VoidCallback? onBack, BuildContext? context})
      : super(
          key: key,
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: Color(0xffffecda),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "BeautyMinder",
            style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xffd86a04),
          ),
          leading: automaticallyImplyLeading
              ? null
              : IconButton(
            onPressed: onBack ?? () => Navigator.of(context!).pop(true),
            icon: Icon(Icons.arrow_back_ios),
          ),
        );
}
