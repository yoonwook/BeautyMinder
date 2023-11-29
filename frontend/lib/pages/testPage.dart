import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  _testPage createState() => _testPage();
}

class _testPage extends State<testPage> {

  getPermission() async{
    // var status = await Permission.camera.status;
    // if(status.isGranted){
    //   print('허락됨');
    // } else if (status.isDenied){
    //   print('거절됨');
    //   Permission.camera.request(); // 허락해달라고 팝업띄우는 코드
    // }
    Map<Permission, PermissionStatus> statuses = await[
      Permission.camera,
      Permission.photos,
      Permission.accessMediaLocation
    ].request();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Text('권한', style: TextStyle(fontSize:  50.0)),
      ),
    );
  }
}