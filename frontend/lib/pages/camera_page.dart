import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try{
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            isCameraInitialized = true;
          });
        });
      }
    }catch(e){
      print("Error : ${e}");
    }

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: CameraPreview(controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takePicture();
        },
        child: Icon(Icons.camera),
      ),
    );
  }

  void takePicture() async {
    try {
      if (controller != null && controller!.value.isInitialized) {
        final image = await controller!.takePicture();
        // 여기에 이미지를 처리하는 로직을 추가하세요. 예: 이미지를 다른 화면으로 전달
      }
    } catch (e) {
      // 사진 촬영에 실패한 경우 처리
      print(e);
    }
  }
}
