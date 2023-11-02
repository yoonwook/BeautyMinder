import 'package:flutter/material.dart';
import 'package:beautyminder/dto/baumann_model.dart';

class BaumannTestPage extends StatefulWidget {
  BaumannTestPage({required this.data});

  final List<BaumannSurveys>? data;
  @override
  _BaumannTestPageState createState() => _BaumannTestPageState();
}

class _BaumannTestPageState extends State<BaumannTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baumann Test Page'),
      ),
      body: ListView.builder(
        itemCount: widget.data?.length ?? 0,
        itemBuilder: (context, index) {
          // 데이터 모델에 따라 텍스트를 추출
          // String a1Question = widget.data![index].a1?.questionKr ?? 'No question available'; // 필드 이름으로 변경

          // return ListTile(
          //   title: Text(a1Question),
          // );

          var data = widget.data![index]; // 해당 데이터 모델에 액세스
          // 데이터 모델로부터 질문 추출
          List<Question?> questions = [
            data.a1, data.a2, data.a3, data.a4, data.a5, data.a6, data.a7, data.a8, data.a9, data.a10, data.a11,
            data.b1, data.b2, data.b3, data.b4, data.b5, data.b6, data.b7, data.b8, data.b9, data.b10, data.b11, data.b12, data.b13, data.b14, data.b15, data.b16,
            data.c1, data.c2, data.c3, data.c4, data.c5, data.c6, data.c7, data.c8, data.c9, data.c10, data.c11, data.c12, data.c13, data.c14,
            data.d1, data.d2, data.d3, data.d4, data.d5, data.d6, data.d7, data.d8, data.d9, data.d10, data.d11, data.d12, data.d13, data.d14, data.d15, data.d16, data.d17, data.d18, data.d19, data.d20, data.d21,
          ];
          return Column(
            children: questions
              .map(
                (question) => ListTile(
                  title: Text(question?.questionKr ?? 'No question available'),
                ),
              ).toList(),
          );
        },
      ),
    );
  }
}
