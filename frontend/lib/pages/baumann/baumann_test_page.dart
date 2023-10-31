import 'package:flutter/material.dart';

import '../../dto/baumann_model.dart';

class BaumannTestPage extends StatefulWidget {
  final List<Baumann> surveys; // 백엔드로부터 받아온 설문지 목록
  BaumannTestPage({required this.surveys});

  @override
  _BaumannTestPageState createState() => _BaumannTestPageState();
}

class _BaumannTestPageState extends State<BaumannTestPage> {
  int currentQuestionIndex = 0; // 현재 표시 중인 문항 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baumann Test Page'),
      ),
      body: baumannTestUI(),
    );
  }

  Widget baumannTestUI(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '문항 ${widget.surveys[currentQuestionIndex].questions['question_kr']}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Column(
            children: (widget.surveys[currentQuestionIndex].questions['options'] as List)
                .map((option) {
              return ElevatedButton(
                onPressed: () {
                  // 사용자가 선택한 옵션 처리
                  int selectedOption = option['option'];
                  // 여기에서 선택한 옵션을 저장하거나 서버로 전송할 수 있습니다.
                  // 이후 문항을 변경하거나 페이지를 업데이트하도록 코드를 추가해야 합니다.
                },
                child: Text(option['description']),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
