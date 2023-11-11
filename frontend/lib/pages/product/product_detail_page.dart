import 'package:beautyminder/dto/cosmetic_model.dart';
import 'package:beautyminder/services/gptReview_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayingName(),
        const SizedBox(height: 50),
        _displayImages(),
        const SizedBox(height: 50),
        _displayBrand(),
        const SizedBox(height: 50),
        _displayCategory(),
        const SizedBox(height: 50),
        _displayKeywords(),
        const SizedBox(height: 50),
        _displayGPTReviewText(),
        const SizedBox(height: 50),
        // _displayGPTReview(),
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
      ],
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
        items: widget.searchResults.images!.map((image) {
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

  Widget _displayBrand() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Brand: ${widget.searchResults.brand}, 이미지 개수: ${widget.searchResults.images!.length}',
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
    print('GPTReviewInfo - Positive Review: ${gptReviewInfo.positive}');
    print('GPTReviewInfo - Negative Review: ${gptReviewInfo.negative}');
    print('GPTReviewInfo - GPT Version: ${gptReviewInfo.gptVersion}');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Positive Review: ${gptReviewInfo.positive}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Negative Review: ${gptReviewInfo.negative}',
            style: TextStyle(fontSize: 16),
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
}