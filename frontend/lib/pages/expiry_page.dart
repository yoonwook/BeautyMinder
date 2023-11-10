import 'package:flutter/material.dart';

import '../dto/cosmetic_model.dart';
import '../dto/cosmetic_expiry_model.dart';

import '../services/expiry_service.dart';
import '../services/api_service.dart';
import '../services/search_service.dart';

class CosmeticExpiryPage extends StatefulWidget {
  @override
  _CosmeticExpiryPageState createState() => _CosmeticExpiryPageState();
}

class _CosmeticExpiryPageState extends State<CosmeticExpiryPage> {
  List<CosmeticExpiry> cosmetics = [];

  @override
  void initState() {
    super.initState();
    _loadExpiryData();
  }

  void _loadExpiryData() async {
    final result = await APIService.getUserProfile();
    final userId = result.isSuccess ? result.value?.id ?? '-1' : '-1';  // 사용자 프로필을 가져오지 못하면 기본값 '-1'을 사용
    final expiryData = await ExpiryService.getAllExpiriesByUserId(userId);
    setState(() {
      cosmetics = expiryData;
    });
  }


  void _addCosmetic() async {
    final result = await APIService.getUserProfile();
    final userId = result.isSuccess ? result.value?.id ?? '-1' : '-1';  // 사용자 프로필을 가져오지 못하면 기본값 '-1'을 사용

    final Cosmetic? selectedCosmetic = await showDialog<Cosmetic>(
      context: context,
      builder: (context) => CosmeticSearchWidget(),
    );
    if (selectedCosmetic != null) {
      final List<dynamic>? expiryInfo = await showDialog<List<dynamic>>(
        context: context,
        builder: (context) => ExpiryInputDialog(cosmetic: selectedCosmetic),
      );
      if (expiryInfo != null) {
        final bool isOpened = expiryInfo[0] as bool;
        final DateTime expiryDate = expiryInfo[1] as DateTime;

        final CosmeticExpiry newExpiry = CosmeticExpiry(
          productName: selectedCosmetic.name,
          expiryDate: expiryDate,
          isExpiryRecognized: isOpened,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userId: userId,
          // 다른 필드들도 여기에 추가
        );
        final CosmeticExpiry addedExpiry = await ExpiryService.createCosmeticExpiry(newExpiry);
        setState(() {
          cosmetics.add(addedExpiry);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expiry Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCosmetic,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cosmetics.length,
        itemBuilder: (context, index) {
          final cosmetic = cosmetics[index];
          return ListTile(
            leading: cosmetic.imageUrl != null
                ? Image.network(cosmetic.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image, size: 50), // 이미지가 없는 경우 아이콘 표시
            title: Text(cosmetic.productName),
            subtitle: Text('Expiry Date: ${cosmetic.expiryDate.toLocal().toIso8601String()}'),
            // 여기에 다른 세부 정보와 액션을 추가할 수 있다.
            // 예를 들어, 이 제품에 대한 리뷰나 평점을 표시하고 싶으면 여기에 추가
          );
        },
      ),

    );
  }
}

class CosmeticSearchWidget extends StatefulWidget {
  @override
  _CosmeticSearchWidgetState createState() => _CosmeticSearchWidgetState();
}

class _CosmeticSearchWidgetState extends State<CosmeticSearchWidget> {
  List<Cosmetic> cosmetics = [];
  String query = '';

  void _search() async {
    if (query.isNotEmpty) {
      try {
        // SearchService를 사용하여 서버에서 화장품을 검색
        cosmetics = await SearchService.searchCosmeticsByName(query);
        setState(() {
          // 검색 결과로 UI를 업데이트
        });
      } catch (e) {
        print('Search error: $e');
        // 필요하면 setState를 사용하여 UI에 에러 메시지를 표시
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (text) {
            query = text;
          },
          onSubmitted: (text) {
            _search();
          },
          decoration: InputDecoration(
            hintText: 'Search cosmetics...',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cosmetics.length,
        itemBuilder: (context, index) {
          final cosmetic = cosmetics[index];
          return ListTile(
            title: Text(cosmetic.name),
            onTap: () {
              Navigator.of(context).pop(cosmetic);
            },
          );
        },
      ),
    );
  }
}

class ExpiryInputDialog extends StatefulWidget {
  final Cosmetic cosmetic;

  ExpiryInputDialog({required this.cosmetic});

  @override
  _ExpiryInputDialogState createState() => _ExpiryInputDialogState();
}

class _ExpiryInputDialogState extends State<ExpiryInputDialog> {
  bool isOpened = false;
  DateTime expiryDate = DateTime.now().add(Duration(days: 365));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != expiryDate)
      setState(() {
        expiryDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter expiry info for ${widget.cosmetic.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('Opened'),
            value: isOpened,
            onChanged: (bool value) {
              setState(() {
                isOpened = value;
              });
            },
          ),
          ListTile(
            title: Text("${expiryDate.toLocal()}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop([isOpened, expiryDate]);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
