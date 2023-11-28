import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/cosmetic_expiry_model.dart';

class CosmeticDetailsDialog extends StatelessWidget {
  final CosmeticExpiry cosmetic;

  CosmeticDetailsDialog({required this.cosmetic});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(cosmetic.productName),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('유통기한: ${formatDate(cosmetic.expiryDate)}까지'),
          Text(
              (cosmetic.isOpened == true) ?
              '개봉여부: 개봉' : '개봉여부: 미개봉'
          ),
          Text(
              (cosmetic.isOpened == true) ?
              '개봉일: ${formatDate(cosmetic.openedDate)}' : '개봉일: N/A'
          ),
          // Add other details as needed
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('닫기'),
        ),
      ],
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return 'N/A'; // 날짜가 null인 경우 처리
  return DateFormat('yyyy-MM-dd').format(date); // 날짜를 'yyyy-MM-dd' 형식으로 변환
}