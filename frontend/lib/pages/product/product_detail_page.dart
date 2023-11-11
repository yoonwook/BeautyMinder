import 'package:beautyminder/dto/cosmetic_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.searchResults}) : super(key: key);

  final Cosmetic searchResults;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

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
        _displayImages(),
        _displayBrand(),
        _displayCategory(),
        _displayKeywords(),
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
}