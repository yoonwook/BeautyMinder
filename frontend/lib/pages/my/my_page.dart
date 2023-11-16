import 'package:beautyminder/dto/user_model.dart';
import 'package:beautyminder/pages/my/my_favorite_page.dart';
import 'package:beautyminder/pages/my/my_review_page.dart';
import 'package:beautyminder/pages/my/user_info_page.dart';
import 'package:beautyminder/pages/my/widgets/my_divider.dart';
import 'package:beautyminder/pages/my/widgets/my_page_header.dart';
import 'package:beautyminder/services/shared_service.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonBottomNavigationBar.dart';
import '../home/home_page.dart';
import '../pouch/pouch_page.dart';
import '../recommend/recommend_bloc_screen.dart';
import '../todo/todo_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  User? user;
  bool isLoading = true;
  int _currentIndex = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    try {
      final info = await SharedService.loginDetails();
      setState(() {
        user = info!.user;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: Text('로딩 중'))
        : Scaffold(
      appBar: CommonAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyPageHeader('마이페이지'),
                const SizedBox(height: 20),
                MyPageProfile(
                    nickname: user!.nickname ?? user!.email,
                    profileImage: user!.profileImage ?? ''),
                const SizedBox(height: 20),
                const MyDivider(),
                MyPageMenu(
                    title: '즐겨찾기 해둔 제품',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyFavoritePage()),
                      );
                    }),
                MyPageMenu(
                  title: '내가 쓴 리뷰',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyReviewPage()),
                    );
                  },
                ),
                MyPageMenu(
                  title: '로그아웃',
                  onTap: () {
                    SharedService.logout(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: _underNavigation(),
    );
  }

  Widget _underNavigation() {
    return CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // 페이지 전환 로직 추가
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecPage()));
          }
          else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PouchPage()));
          }
          else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          }
          else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoPage()));
          }
        }
    );
  }
}

class MyPageProfile extends StatelessWidget {
  final String nickname;
  final String profileImage;

  const MyPageProfile(
      {super.key, required this.nickname, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Image.asset(
              'assets/images/profile.jpg', // profileImage,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/profile.jpg');
              },
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            child: Text(''),
            onPressed: () {
              print(profileImage);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nickname,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF585555),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_right,
                        color: Color(0xFFFE9738),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => UserInfoPage())));
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyPageMenu extends StatelessWidget {
  final String title;
  VoidCallback? onTap;

  MyPageMenu({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF868383),
              ),
              textAlign: TextAlign.left,
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_right,
                color: Color(0xFFFE9738),
              ),
              onPressed: () {
                onTap?.call();
              },
            )
          ],
        ),
      ),
    );
  }
}
