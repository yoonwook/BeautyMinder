import 'package:beautyminder/dto/cosmetic_model.dart';
import 'package:beautyminder/pages/recommend/recommend_page.dart';
import 'package:beautyminder/pages/todo/todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/commonAppBar.dart';
import '../../widget/commonBottomNavigationBar.dart';
import '../home/home_page.dart';
import '../my/my_page.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.searchResults.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Displaying Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.searchResults.images![0],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Displaying Brand
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Brand: ${widget.searchResults.brand}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Displaying Category
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Category: ${widget.searchResults.category}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Displaying Keywords
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Keywords: ${widget.searchResults.keywords}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}