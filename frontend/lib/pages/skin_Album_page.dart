import 'package:beautyminder/pages/pouch_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:beautyminder/pages/todo_page.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:local_image_provider/local_image_provider.dart' as lip;
import '../widget/commonBottomNavigationBar.dart';
import 'FullScreenImagePage.dart';
import 'home_page.dart';
import 'my_page.dart';

class skinAlbumPage extends StatefulWidget {
  const skinAlbumPage({Key? key}) : super(key: key);

  @override
  _skinAlbumPage createState() => _skinAlbumPage();
}

class _skinAlbumPage extends State<skinAlbumPage> {

  String selectedFilter = "all";

  bool isPhotoInTimeRange(LocalImage image, String filter) {
    DateTime now = DateTime.now();
    DateTime? imageDate = image.creationDate;

    if (imageDate == null) return false;

    switch (filter) {
      case 'Today':
        return imageDate.year == now.year &&
            imageDate.month == now.month &&
            imageDate.day == now.day;
      case 'This Week':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return imageDate.isAfter(startOfWeek) && imageDate.isBefore(now.add(Duration(days: 1)));
      case 'This Month':
        return imageDate.year == now.year && imageDate.month == now.month;
      default: // 'All'
        return true;
    }
  }

  var _currentIndex = 2;

  getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.accessMediaLocation,
      Permission.storage
    ].request();

    print("statuses[Permission.camera] : ${statuses[Permission.camera]}");
    print("Permission.photos : ${statuses[Permission.photos]}");
    print(
        "Permission.accessMediaLocation : ${statuses[Permission.accessMediaLocation]}");
    print("Permission.storage : ${statuses[Permission.storage]}");
  }

  @override
  void initState() {
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
      appBar: CommonAppBar(),
      body: FutureBuilder<List<LocalImage>>(
        future: getLocalImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: [
                const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('전체', style: TextStyle(fontSize: 50.0)),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 7.0,
                    crossAxisSpacing: 0.0,
                    children: snapshot.data!
                        .map((e) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenImagePage(image: e),
                                  ),
                                );
                              },
                              child: Image(image: DeviceImage(e)),
                            ))
                        .toList(),
                    //padding: const EdgeInsets.all(7.0),
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
                        iconSize: 80.0),
                  ],
                )
              ],
            );
          }

          // Handle the case where there's no data
          return Center(child: Text('No images found'));
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            // 페이지 전환 로직 추가
            if (index == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RecPage()));
            } else if (index == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PouchPage()));
            } else if (index == 2) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else if (index == 3) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TodoPage()));
            } else if (index == 4) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPage()));
            }
          }),
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
