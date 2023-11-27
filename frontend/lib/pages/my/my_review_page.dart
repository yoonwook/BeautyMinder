import 'package:beautyminder/pages/my/widgets/default_dialog.dart';
import 'package:beautyminder/pages/my/widgets/pop_up.dart';
import 'package:beautyminder/pages/my/widgets/delete_popup.dart';
import 'package:beautyminder/pages/my/widgets/update_dialog.dart';
import 'package:beautyminder/services/api_service.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:beautyminder/pages/my/widgets/my_page_header.dart';

class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key});

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  List<dynamic>? reviews;
  bool isLoading = true;

  void updateParentVariable() {
    getReviews();
  }

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  getReviews() async {
    try {
      final info = await APIService.getReviews();
      setState(() {
        reviews = info.value;
        isLoading = false;
      });
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return isLoading
        ? SpinKitThreeInOut(
      color: Color(0xffd86a04),
      size: 50.0,
      duration: Duration(seconds: 2),
    )
        : Column(
      children: [
        Padding(  // 제목을 가운데로 조정하기 위한 Padding
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MyPageHeader('내가 쓴 리뷰'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: reviews?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              reviews?[index]['cosmetic']['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                FilledButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Colors.orange)),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            UpdateDialog(
                                              onBarrierTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              title: reviews?[index]
                                              ['cosmetic']['name'],
                                              review: reviews?[index],
                                              callback: updateParentVariable,
                                            ),
                                      );
                                    },
                                    child: Text('수정')),
                                SizedBox(
                                  width: 5,
                                ),
                                FilledButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Colors.orange)),
                                    onPressed: () async {
                                      final ok = await deletePopUp(
                                          context: context,
                                          title: '정말 삭제하시겠습니까?',
                                          callback: updateParentVariable,
                                          id: reviews?[index]['id']);
                                    },
                                    child: Text('삭제'))
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          reviews?[index]['content'],
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}