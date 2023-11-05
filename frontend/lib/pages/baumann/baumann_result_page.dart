import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';

class BaumannResultPage extends StatefulWidget {
  const BaumannResultPage({Key? key}) : super(key: key);

  @override
  _BaumannResultPageState createState() => _BaumannResultPageState();
}

class _BaumannResultPageState extends State<BaumannResultPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Text('Baumann Result'),
    );
  }

}