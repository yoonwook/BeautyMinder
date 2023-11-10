import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/dto/user_model.dart';
import '/dto/cosmetic_model.dart';
import '/dto/review_response_model.dart'; // ReviewResponse 모델 사용
import '/dto/review_request_model.dart'; // ReviewRequest 모델 사용
import '/services/review_service.dart';
import '/services/search_service.dart';
import '/services/shared_service.dart';

class CosmeticReviewPage extends StatefulWidget {
  @override
  _CosmeticReviewPageState createState() => _CosmeticReviewPageState();
}

class _CosmeticReviewPageState extends State<CosmeticReviewPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Cosmetic> _searchResults = [];
  List<ReviewResponse> _cosmeticReviews = []; // ReviewResponse 리스트로 변경
  bool _isLoading = false;
  String _selectedCosmeticId = '';
  final ImagePicker _picker = ImagePicker();
  List<PlatformFile>? _imageFiles;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCosmetics() async {
    setState(() => _isLoading = true);
    try {
      var results = await SearchService.searchCosmeticsByName(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Search failed: $e');
    }
  }

  void _fetchReviewsForCosmetic(String cosmeticId) async {
    setState(() => _isLoading = true);
    try {
      var reviews = await ReviewService.getReviewsForCosmetic(cosmeticId);
      setState(() {
        _cosmeticReviews = reviews;
        _selectedCosmeticId = cosmeticId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to load reviews: $e');
    }
  }

  void getImages() async {
    try {

      _imageFiles = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
      ?.files;

      // setState(() {
      //   _imageFiles = paths;
      // });
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> _selectImages() async {
  //   final List<XFile>? selectedImages = await _picker.pickMultiImage();
  //   if (selectedImages != null && selectedImages.isNotEmpty) {
  //     setState(() {
  //       _imageFiles = selectedImages;
  //     });
  //   }
  // }

  void _addOrEditReview(ReviewResponse? review) async {
    User? user = await SharedService.getUser();
    if (user != null) {
      // 로그인한 사용자의 ID를 가져옵니다.
      String userId = user.id;
      _showReviewDialog(reviewToUpdate: review, userId: userId);
    } else {
      // 사용자 정보를 가져오지 못했을 때의 처리
      _showSnackBar('You need to be logged in to add a review.');
    }
  }

  void _showReviewDialog({ReviewResponse? reviewToUpdate, required String userId}) async {
    final _contentController = TextEditingController();
    int _rating = reviewToUpdate?.rating ?? 1;
    if (reviewToUpdate != null) {
      _contentController.text = reviewToUpdate.content;
    }


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reviewToUpdate == null ? 'Write a Review' : 'Edit Review'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Enter your review here',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                DropdownButton<int>(
                  value: _rating,
                  items: List.generate(
                    5,
                        (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} Stars'),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _rating = value;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: getImages,
                  child: Text('Select Images'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                final String content = _contentController.text;
                if (content.isNotEmpty && _selectedCosmeticId.isNotEmpty) {
                  // 이미지 파일 경로 리스트를 생성합니다.
                  // List<File> imageFiles = _imageFiles?.map((xFile) => File(xFile.path)).toList() ?? [];

                  // 새로운 리뷰 요청 객체 생성
                  ReviewRequest newReviewRequest = ReviewRequest(
                    content: content,
                    rating: _rating,
                    cosmeticId: _selectedCosmeticId, // 선택한 화장품의 ID
                    userId: userId, // 사용자의 ID
                  );


                  try {
                    // 리뷰를 추가하거나 업데이트합니다.
                    ReviewResponse responseReview;
                    if (reviewToUpdate == null) {
                      // 새 리뷰 추가
                      responseReview = await ReviewService.addReview(newReviewRequest, _imageFiles!);
                    } else {
                      // 기존 리뷰 업데이트 (세 개의 위치 인자를 전달)
                      responseReview = await ReviewService.updateReview(reviewToUpdate.id, newReviewRequest, _imageFiles!);
                    }

                    setState(() {
                      if (reviewToUpdate == null) {
                        _cosmeticReviews.add(responseReview);
                      } else {
                        int index = _cosmeticReviews.indexWhere((review) => review.id == responseReview.id);
                        if (index != -1) {
                          _cosmeticReviews[index] = responseReview;
                        }
                      }
                      _searchResults.clear();
                      _searchController.clear();
                    });
                    Navigator.of(context).pop();
                    _showSnackBar(reviewToUpdate == null ? 'Review added successfully' : 'Review updated successfully');
                  } catch (e) {
                    Navigator.of(context).pop();
                    _showSnackBar('Failed to add/update review: $e');
                  }
                } else {
                  _showSnackBar('Review content cannot be empty');
                }
              },
            ),
          ],
        );
      },
    );
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildReviewList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _cosmeticReviews.length,
        itemBuilder: (context, index) {
          var review = _cosmeticReviews[index];
          return Card(
            child: ListTile(
              title: Text('Rating: ${review.rating}'),
              subtitle: Text(review.content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _addOrEditReview(review);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _deleteReview(review.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteReview(String reviewId) async {
    setState(() => _isLoading = true);
    try {
      // await ReviewService.deleteReview(reviewId);
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
      appBar: AppBar(
        title: Text('Cosmetic Reviews'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Cosmetics',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchCosmetics,
                ),
              ),
              onSubmitted: (value) => _searchCosmetics(),
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var cosmetic = _searchResults[index];
                  return ListTile(
                    title: Text(cosmetic.name),
                    subtitle: Text('ID: ${cosmetic.id}'),
                    onTap: () => _fetchReviewsForCosmetic(cosmetic.id),
                  );
                },
              ),
            ),
          Divider(),
          if (!_isLoading && _selectedCosmeticId.isNotEmpty) _buildReviewList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedCosmeticId.isNotEmpty) {
            _addOrEditReview(null);
          } else {
            _showSnackBar('Please select a cosmetic to review.');
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
