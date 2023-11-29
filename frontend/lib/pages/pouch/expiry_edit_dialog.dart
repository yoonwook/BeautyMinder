import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../dto/cosmetic_expiry_model.dart';
import '../../dto/vision_response_dto.dart';
import '../../services/ocr_service.dart';

class ExpiryEditDialog extends StatefulWidget {
  final CosmeticExpiry expiry;
  final Function(CosmeticExpiry) onUpdate;

  ExpiryEditDialog({required this.expiry, required this.onUpdate});

  @override
  _ExpiryEditDialogState createState() => _ExpiryEditDialogState();
}

class _ExpiryEditDialogState extends State<ExpiryEditDialog> {
  late bool opened;
  late DateTime expiryDate;
  DateTime? openedDate;

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    opened = widget.expiry.opened;
    expiryDate = widget.expiry.expiryDate;
    openedDate = widget.expiry.openedDate;
  }


  Future<void> _selectDate(BuildContext context,
      {bool isExpiryDate = true}) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isExpiryDate ? expiryDate : openedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, // 달력의 주요 색상을 오렌지로 설정
            ),
            // primaryColor: Colors.grey, // 배경색
            // hintColor: Colors.orange, // 선택된 날짜의 색상
            // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
  Future<void> _navigateAndProcessOCR() async {
    final PlatformFile? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    ).then((result) => result?.files.first);

    if (pickedFile != null) {
      // OCR 처리를 요청하고 결과를 받습니다.
      try {
        print("SUCK: ${pickedFile}");
        final response = await OCRService.selectAndUploadImage(pickedFile);
        print("FUCK: ${response}");
        if (response != null) {
          final VisionResponseDTO result = VisionResponseDTO.fromJson(response);
          final expiryDateFromOCR = DateFormat('yyyy-MM-dd').parse(result.data);

          // 받아온 유통기한으로 상태 업데이트
          setState(() {
            expiryDate = expiryDateFromOCR;
          });
        }
      } catch (e) {
        print("hello");
        // 오류 처리
        _showErrorDialog(e.toString());
      }
    } else {
      _showErrorDialog("No image selected for OCR.");
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      title: Text(
        '\'${widget.expiry.productName}\' 정보 수정',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        // overflow: TextOverflow.ellipsis,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  '개봉 여부',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                value: opened,
                onChanged: (bool value) {
                  setState(() {
                    opened = value;
                    if (!opened) {
                      openedDate = null;
                    }
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.orange,
              ),
              ListTile(
                title: Text(
                  '유통기한: ${formatDate(expiryDate)}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),

              // ListTile(
              //   title: Text('OCR'),
              //   trailing: Icon(Icons.calendar_today),
              //   onTap: () =>_navigateAndProcessOCR() ,
              // ),

              if (opened)
                ListTile(
                  title: Text(openedDate != null
                      ? '개봉 날짜: ${formatDate(openedDate!)}'
                      : '개봉 날짜 선택',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, isExpiryDate: false),
                ),
            ],
          );
        },
      ),
      actions: [
        Container(
          width: 70,
          height: 30,
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
            onPressed: () {
              // 새로운 CosmeticExpiry 객체 생성 및 현재 상태로 업데이트
              CosmeticExpiry updatedExpiry = CosmeticExpiry(
                id: widget.expiry.id,
                productName: widget.expiry.productName,
                brandName: widget.expiry.brandName,
                expiryDate: expiryDate,
                expiryRecognized: widget.expiry.expiryRecognized,
                imageUrl: widget.expiry.imageUrl,
                cosmeticId: widget.expiry.cosmeticId,
                opened: opened,
                openedDate: openedDate, // 수정된 openedDate
              );
              widget.onUpdate(updatedExpiry);
              Navigator.of(context).pop(updatedExpiry);
              Navigator.of(context).pop(updatedExpiry);
            },
            child: Text(
              '수정',
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
