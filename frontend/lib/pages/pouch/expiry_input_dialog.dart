import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../dto/cosmetic_model.dart';
import '../../dto/vision_response_dto.dart';
import '../../services/ocr_service.dart';

class ExpiryInputDialog extends StatefulWidget {
  final Cosmetic cosmetic;

  ExpiryInputDialog({required this.cosmetic});

  @override
  _ExpiryInputDialogState createState() => _ExpiryInputDialogState();
}

class _ExpiryInputDialogState extends State<ExpiryInputDialog> {
  bool isOpened = false;

  //DateTime expiryDate = DateTime.now().add(Duration(days: 365));
  DateTime? expiryDate = DateTime.now();
  DateTime? openedDate = DateTime.now(); // 개봉 날짜 기본값

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context,
      {bool isExpiryDate = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isExpiryDate ? expiryDate : openedDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, // 달력의 주요 색상을 오렌지로 설정
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isExpiryDate) {
          expiryDate = picked;
        } else {
          openedDate = picked;
        }
      });
    }
  }

  // OCR 페이지로 이동하고 결과를 받아오는 함수
  Future<void> _navigateAndProcessOCR(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      // 이미지 자르기
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.orange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Crop Image',
            )
          ]
      );

      if (croppedFile != null) {
        final file = File(croppedFile.path);
        final fileName = file.path.split('/').last;
        final fileSize = await file.length();
        final fileBytes = await file.readAsBytes();

        try {
          // OCR 서비스 호출
          final response = await OCRService.selectAndUploadImage(PlatformFile(
            name: fileName,
            bytes: fileBytes,
            size: fileSize,
            path: croppedFile.path,
          ));

          if (response != null) {
            // OCR 결과 처리
            final VisionResponseDTO result = VisionResponseDTO.fromJson(response);
            final expiryDateFromOCR = DateFormat('yyyy-MM-dd').parse(result.data);

            setState(() {
              expiryDate = expiryDateFromOCR;
            });
          }
        } catch (e) {
          // 오류 처리
          _showErrorDialog(e.toString());
        }
      }
    } else {
      // 이미지 선택 안됨 오류 처리
      _showErrorDialog("OCR을 위한 이미지가 선택되지 않았습니다.");
    }
  }

  // 에러 메시지를 보여주는 함수
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // 유통기한 선택 방법을 선택하는 다이얼로그를 표시하는 함수
  void _showExpiryDateChoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('유통기한 입력 방법 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('직접 입력'),
              onTap: () {
                Navigator.of(context).pop();
                _selectDate(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('카메라로 촬영'),
              onTap: () {
                Navigator.of(context).pop();
                _navigateAndProcessOCR(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('이미지 앨범에서 선택'),
              onTap: () {
                Navigator.of(context).pop();
                _navigateAndProcessOCR(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.cosmetic.name}의 유통기한 정보를 입력해주세요'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('개봉여부'),
            value: isOpened,
            onChanged: (bool value) {
              setState(() {
                isOpened = value;
                if (!isOpened) {
                  openedDate = null;
                }
              });
            },
            activeColor: Colors.orange,
            activeTrackColor: Colors.orangeAccent,
          ),
          ListTile(
            title: Text(expiryDate != null
                ? '유통기한: ${formatDate(expiryDate!)}'
                : '유통기한 선택'),
            trailing: Icon(Icons.calendar_today),
            onTap: () =>
                _showExpiryDateChoiceDialog(), // 유통기한 선택 방법을 선택하는 다이얼로그를 표시하는 함수 호출
          ),
          if (isOpened)
            ListTile(
              title: Text(openedDate != null
                  ? '개봉 날짜: ${formatDate(openedDate!)}'
                  : '개봉 날짜 선택'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, isExpiryDate: false),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop([isOpened, expiryDate, openedDate]),
          child: Text('등록'),
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
        ),
      ],
    );
  }
}
