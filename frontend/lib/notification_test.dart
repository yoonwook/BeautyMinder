import 'package:beautyminder/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notitest extends StatefulWidget {
  const notitest({Key? key}) : super(key: key);

  @override
  _notitest createState() => _notitest();
}

class _notitest extends State<notitest> {
  @override
  void initState() {
    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            FlutterLocalNotification.showNotification_time('title',
                'description', FlutterLocalNotification.makeDate(20, 53, 00));
          },
          child: const Text('알림 보내기'),
        ),
      ),
    );
  }
}
