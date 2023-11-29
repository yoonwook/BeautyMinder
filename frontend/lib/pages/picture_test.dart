import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart' as lip;
import 'package:permission_handler/permission_handler.dart';

import 'FullScreenImagePage.dart';

class picturePage extends StatefulWidget {
  const picturePage({Key? key}) : super(key: key);

  @override
  _picturePage createState() => _picturePage();
}

class _picturePage extends State<picturePage> {

  getPermission() async{
    Map<Permission, PermissionStatus> statuses = await[
      Permission.camera,
      Permission.photos,
      Permission.accessMediaLocation,
      Permission.storage
    ].request();

    print("statuses[Permission.camera] : ${statuses[Permission.camera]}");
    print("Permission.photos : ${statuses[Permission.photos]}");
    print("Permission.accessMediaLocation : ${statuses[Permission.accessMediaLocation]}");
    print("Permission.storage : ${statuses[Permission.storage]}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  Future<List<LocalImage>> getLocalImages() async {
    print("this is getLocalImages");
    lip.LocalImageProvider imageProvider = lip.LocalImageProvider();
    bool hasPermission = await imageProvider.initialize();
    print("hasPermission : ${hasPermission}");
    if (hasPermission) {
      //최근 이미지 30개 가져오기
      List<LocalImage> images = await imageProvider.findLatest(30);
      if (images.isNotEmpty) {
        return images;
      } else {
        print('이미지를 찾을 수 없습니다.');
        throw '이미지를 찾을 수 없습니다.';

      }
    } else {
      throw '이미지에 접근할 권한이 없습니다.';
      print('이미지에 접근할 권한이 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LocalImage>>(
        future: getLocalImages(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                  child: Center(
                child: Text('사진 저장하기', style: TextStyle(fontSize: 50.0)),
              )),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: snapshot.data!
                      .map((e) => GestureDetector(
                    onTap: () {
                      // 여기에 사진을 크게 보여주는 로직을 구현하세요
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(image: e),
                        ),
                      );
                    },
                    child: Image(image: DeviceImage(e)),
                  ))
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        _takePhoto();
                      },
                      icon: Icon(Icons.camera_alt_outlined),
                      iconSize: 50.0),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void _takePhoto() async {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null && value.path != null) {
        print("저장경로  : ${value.path}");

        GallerySaver.saveImage(value.path).then((value) {
          print("사진이 저장되었습니다.");
        });
      }
    });
  }
}
