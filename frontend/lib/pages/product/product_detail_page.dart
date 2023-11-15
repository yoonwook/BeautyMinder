import 'package:beautyminder/dto/cosmetic_model.dart';
import 'package:beautyminder/pages/product/review_page.dart';
import 'package:beautyminder/services/gptReview_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../dto/gptReview_model.dart';
import '../../widget/commonAppBar.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.searchResults}) : super(key: key);

  final Cosmetic searchResults;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Result<GPTReviewInfo>> _gptReviewInfo;
  bool showPositiveReview = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _gptReviewInfo = GPTReviewService.getGPTReviews(widget.searchResults.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: _productDetailPageUI(),
      ),
    );
  }

  Widget _productDetailPageUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _displayingName(),
          const SizedBox(height: 50),
          _displayImages(),
          const SizedBox(height: 50),
          _likesBtn(),
          _displayBrand(),
          _displayCategory(),
          _displayKeywords(),
          _displayRatingStars(),
          _displayGPTReviewText(),
          const SizedBox(height: 50),
          FutureBuilder<Result<GPTReviewInfo>>(
            future: _gptReviewInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              else if (!snapshot.hasData || !snapshot.data!.isSuccess) {
                return Text('Failed to load GPT review information');
              }
              else {
                final gptReviewInfo = snapshot.data!.value!;
                return _displayGPTReview(gptReviewInfo);
              }
            },
          ),
          _watchAllReviewsButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _displayingName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.searchResults.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _displayImages() {
    return Container(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 500,
          enableInfiniteScroll: false, //무한스크롤 비활성
          viewportFraction: 1.0, //이미지 전체 화면 사용
          aspectRatio: 16/9, //가로 세로 비율 유지
        ),
        items: widget.searchResults.images.map((image) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              image,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _likesBtn() {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite  = !isFavorite;
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
    );
  }

  Widget _displayBrand() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
        Text(
          'Brand: ${widget.searchResults.brand}, 이미지 개수: ${widget.searchResults.images.length}',
          style: TextStyle(fontSize: 16),
         ),
    );
  }

  Widget _displayCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Category: ${widget.searchResults.category}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _displayKeywords() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Keywords: ${widget.searchResults.keywords}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _displayRatingStars() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Rating: ${widget.searchResults.averageRating}',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8.0),
          RatingBar.builder(
            initialRating: widget.searchResults.averageRating, // Set the initial rating
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // Handle rating updates if needed
            },
          ),
        ],
      ),
    );
  }

  Widget _displayGPTReviewText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'ChatGPT-4 리뷰 요약',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _displayGPTReview(GPTReviewInfo gptReviewInfo) {
    // print('GPTReviewInfo - Positive Review: ${gptReviewInfo.positive}');
    // print('GPTReviewInfo - Negative Review: ${gptReviewInfo.negative}');
    // print('GPTReviewInfo - GPT Version: ${gptReviewInfo.gptVersion}');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ToggleButtons(
                  children: [
                    Text('Positive Review'),
                    Text('Negative Review'),
                  ],
                  isSelected: [showPositiveReview, !showPositiveReview],
                  onPressed: (index) {
                    setState(() {
                      showPositiveReview = index == 0;
                    });
                  },
                ),
              ),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: Text(
              showPositiveReview ? gptReviewInfo.positive : gptReviewInfo.negative,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'GPT Version: ${gptReviewInfo.gptVersion}',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  //리뷰 전체보기 버튼
  Widget _watchAllReviewsButton() {
    return ElevatedButton(
      onPressed: () {
        // 클릭 시 AllReviewPage로 이동
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AllReviewPage(cosmeticId : widget.searchResults.id)),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CosmeticReviewPage(cosmeticId: widget.searchResults.id,)),
        );
      },
      child: Text('리뷰 전체보기'),
    );
  }
}