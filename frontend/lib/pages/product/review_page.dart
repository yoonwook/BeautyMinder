import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '/widget/commonAppBar.dart';
import '/dto/user_model.dart';
import '/services/shared_service.dart';
import '/dto/review_request_model.dart';
import '/dto/review_response_model.dart';
import '/services/review_service.dart';

class CosmeticReviewPage extends StatefulWidget {
  final String cosmeticId;

  CosmeticReviewPage({Key? key, required this.cosmeticId}) : super(key: key);

  @override
  _CosmeticReviewPageState createState() => _CosmeticReviewPageState();
}

class _CosmeticReviewPageState extends State<CosmeticReviewPage> {
  List<ReviewResponse> _cosmeticReviews = [];
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? _imageFiles;

  @override
  void initState() {
    super.initState();
    _fetchReviewsForCosmetic(widget.cosmeticId);
  }

  void _fetchReviewsForCosmetic(String cosmeticId) async {
    setState(() => _isLoading = true);
    try {
      var reviews = await ReviewService.getReviewsForCosmetic(cosmeticId);
      setState(() {
        _cosmeticReviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to load reviews: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        PlatformFile file = PlatformFile(
          name: image.name,
          path: image.path,
          size: await image.length(),
          bytes: await image.readAsBytes(),
        );
        setState(() {
          _imageFiles = [file]; // Store the selected image file.
        });
      } else {
        _showSnackBar('No image selected.');
      }
    } on PlatformException catch (e) {
      log('Unsupported operation : ' + e.toString());
    } catch (e) {
      log(e.toString());
      _showSnackBar('Failed to pick image: $e');
    }
  }

  void _addOrEditReview(ReviewResponse? review) async {
    User? user = await SharedService.getUser();
    if (user != null) {
      String userId = user.id;
      _showReviewDialog(reviewToUpdate: review, userId: userId);
    } else {
      _showSnackBar('You need to be logged in to add a review.');
    }
  }

  void _showReviewDialog({ReviewResponse? reviewToUpdate, required String userId}) async {
    final _contentController = TextEditingController();
    int _localRating = reviewToUpdate?.rating ?? 3;
    if (reviewToUpdate != null) {
      _contentController.text = reviewToUpdate.content;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder( // 모서리 둥글게
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(
                reviewToUpdate == null ? '리뷰 작성' : 'Edit Review',
                style: TextStyle(
                  fontFamily: 'YourCustomFont',
                  fontWeight: FontWeight.bold
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '*실제 사용 확인을 위해 이미지 등록은 필수입니다.'
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: _contentController,
                      cursorColor: Color(0xffd77c00),
                      decoration: InputDecoration(
                        hintText: '리뷰를 작성해주세요',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // 테두리 색상을 회색(Colors.grey)으로 변경
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffd77c00)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    DropdownButton<int>(
                      value: _localRating,
                      items: List.generate(
                        5,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1} Stars'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => _localRating = value);
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: Text('사진 추가'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color(0xfff3bb88), // 텍스트 색상을 흰색으로 설정
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  height: 30,
                  width: 70,
                  // color: Colors.white,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 내용물과의 간격을 없애기 위해 추가
                      // backgroundColor: Color(0xffdc7e00),
                      foregroundColor: Color(0xffdc7e00),
                      side: BorderSide(color: Color(0xffdc7e00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Color(0xffd77c00),
                        fontSize: 18
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Container(
                  height: 30,
                  width: 70,
                  color: Color(0xffd77c00),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 내용물과의 간격을 없애기 위해 추가
                      backgroundColor: Color(0xffdc7e00),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Color(0xffdc7e00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    child: Text(
                      '제출',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                    onPressed: () async {
                      final String content = _contentController.text;
                      if (content.isNotEmpty && widget.cosmeticId.isNotEmpty) {
                        ReviewRequest newReviewRequest = ReviewRequest(
                          content: content,
                          rating: _localRating,
                          cosmeticId: widget.cosmeticId,
                        );

                        if (_imageFiles == null || _imageFiles!.isEmpty) {
                          _showSnackBar('리뷰사진을 추가해주세요!');
                          return;
                        }

                        try {
                          ReviewResponse responseReview;
                          if (reviewToUpdate == null) {
                            responseReview = await ReviewService.addReview(
                                newReviewRequest, _imageFiles!);
                          } else {
                            responseReview = await ReviewService.updateReview(
                                reviewToUpdate.id,
                                newReviewRequest,
                                _imageFiles!);
                          }

                          setState(() {
                            if (reviewToUpdate == null) {
                              _cosmeticReviews.add(responseReview);
                            } else {
                              int index = _cosmeticReviews.indexWhere(
                                      (review) => review.id == responseReview.id);
                              if (index != -1) {
                                _cosmeticReviews[index] = responseReview;
                              }
                            }
                          });
                          Navigator.of(context).pop();
                          _showSnackBar(reviewToUpdate == null
                              ? 'Review added successfully'
                              : 'Review updated successfully');
                        } catch (e) {
                          Navigator.of(context).pop();
                          _showSnackBar('Failed to add/update review: $e');
                        }
                      } else {
                        _showSnackBar('Review content cannot be empty');
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }



  Widget _buildReviewList() {
    return Expanded(
      child: ListView.separated(
        itemCount: _cosmeticReviews.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          var review = _cosmeticReviews[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Row(
                children: [
                  ...List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                  SizedBox(width: 8),
                  Text(
                    '${review.rating} Stars',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (review.isFiltered)
                      Text(
                        '욕설등의 문구로 필터링 되었습니다.', // 필터링된 메시지 표시
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      )
                    else
                      Text(
                        review.content, // 리뷰 내용 표시
                        style: TextStyle(fontSize: 16),
                      ),
                    SizedBox(height: 10),
                    if (review.nlpAnalysis.isNotEmpty)
                      Text('리뷰 바우만 분석 수치: ${review.nlpAnalysis}')
                    // NLP 분석 결과 표시
                  ],
                ),
              ),
              /***trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  TextButton(
                  child: Text('Edit', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                  _addOrEditReview(review);
                  },
                  ),
                  TextButton(
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                  await _deleteReview(review.id);
                  },
                  ),
                  ],
                  )***/
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteReview(String reviewId) async {
    setState(() => _isLoading = true);
    try {
      // ReviewService를 사용하여 서버에 삭제 요청
      await ReviewService.deleteReview(reviewId);
      // UI의 리뷰 목록에서 해당 리뷰를 제거
      setState(() {
        _cosmeticReviews.removeWhere((review) => review.id == reviewId);
        _isLoading = false;
      });
      _showSnackBar('Review deleted successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to delete review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(automaticallyImplyLeading: true,),
      body: Column(
        children: [
          if (_isLoading)
            Expanded(
              child: Center(
                child: SpinKitThreeInOut(
                  color: Color(0xffd86a04),
                  size: 50.0,
                  duration: Duration(seconds: 2),
                ),
              ),
            )
          else
            _buildReviewList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrEditReview(null); // 리뷰 추가 다이얼로그를 여는 버튼으로 변경
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xffe7a470),
      ),
    );
  }
}