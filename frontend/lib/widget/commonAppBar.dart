import 'package:beautyminder/pages/calendar_page.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key})
      : super(
          key: key,
          backgroundColor: Color(0xffffecda),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "BeautyMinder",
            style: TextStyle(color: Color(0xffd86a04)),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xffd86a04),
          ),
        );
}

class TodoCommonAppBar extends AppBar {
  TodoCommonAppBar({Key? key, required BuildContext context, required VoidCallback onAddPressed})
      : super(
            key: key,
            backgroundColor: Color(0xffffecda),
            elevation: 0,
            centerTitle: false,
            title: const Text(
              "BeautyMinder",
              style: TextStyle(color: Color(0xffd86a04)),
            ),
            iconTheme: const IconThemeData(
              color: Color(0xffd86a04),
            ),
            actions: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CalendarPage()));
                  },
                  icon: const Icon(Icons.add_box_rounded,
                      size: 50, color: Color(0xffd86a04)),
                  label: const Text("추가",
                      style: TextStyle(fontSize: 25, color: Color(0xffd86a04))))
            ]);
}
