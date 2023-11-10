import 'package:flutter/material.dart';
import '/services/search_service.dart';
import '/services/shared_service.dart';

class GeneralSearchPage extends StatefulWidget {
  @override
  _GeneralSearchPageState createState() => _GeneralSearchPageState();
}

class _GeneralSearchPageState extends State<GeneralSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchGeneral() async {
    setState(() => _isLoading = true);
    try {
      String results = await SearchService.searchAnything(_searchController.text);
      setState(() {
        _searchResults = [results]; // 임시로 결과를 문자열 리스트에 넣는다고 가정
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Search failed: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildSearchResultsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var result = _searchResults[index];
          return ListTile(
            title: Text(result),
            // 여기에 탭 기능을 추가하여 결과에 따른 동작을 정의할 수 있습니다.
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Anything',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchGeneral,
                ),
              ),
              onSubmitted: (value) => _searchGeneral(),
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            _buildSearchResultsList(),
        ],
      ),
    );
  }
}
