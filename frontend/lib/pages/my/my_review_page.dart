import 'package:beautyminder/dto/review_model.dart';
import 'package:beautyminder/services/api_service.dart';
import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key});

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  List<dynamic>? reviews;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReviews();
  }

  getReviews() async {
    try {
      final info = await APIService.getReviews();
      setState(() {
        reviews = info.value;
        isLoading = false;
        print(reviews);
      });
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // reviews 데이터 사용법
  // 위 reviews = info; 의 주석을 제거하고,
  // reviews[index].brand 처럼 쓰기.
  // itemCounter는 reviews.length 로 하기.

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
        : ListView.builder(
            itemCount: reviews?.length ?? 0,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white, // 흰색 배경
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                                reviews?[index]['cosmetic']['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              reviews?[index]['content'],
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ]),
                  ),
                ));
  }
}
