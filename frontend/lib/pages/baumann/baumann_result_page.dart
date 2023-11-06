import 'package:beautyminder/dto/baumann_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';

class BaumannResultPage extends StatefulWidget {
  const BaumannResultPage({Key? key/*, required this.resultData*/}) : super(key: key);

  // final Map<String, dynamic> resultData;

  @override
  _BaumannResultPageState createState() => _BaumannResultPageState();
}

class _BaumannResultPageState extends State<BaumannResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: baumannResultUI(),
    );
  }


  Widget baumannResultUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('result Page'),
        ],
      ),
    );
  }

}