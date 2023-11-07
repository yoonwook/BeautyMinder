import 'dart:convert';

import 'package:beautyminder/pages/baumann/baumann_result_page.dart';
import 'package:beautyminder/widget/baumannTestAppBar.dart';
import 'package:flutter/material.dart';
import 'package:beautyminder/dto/baumann_model.dart';
import 'package:beautyminder/globalVariable/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config.dart';
import '../../services/baumann_service.dart';

class BaumannTestPage extends StatefulWidget {
  const BaumannTestPage({Key? key, required this.data}) : super(key: key);

  final SurveyWrapper data;

  @override
  _BaumannTestPageState createState() => _BaumannTestPageState();
}

class _BaumannTestPageState extends State<BaumannTestPage> {

  int currentPage = 0; // 현재 페이지 인덱스
  List<QuestionPage> pages = [];
  Map<String, int?> selectedOptionIndices = {};


  @override
  void initState() {
    super.initState();

    // 페이지 목록을 생성합니다.
    for (String surveyKey in widget.data.surveys.keys) {
      BaumannSurveys survey = widget.data.surveys[surveyKey]!;
      pages.add(QuestionPage(surveyKey, survey.questionKr, survey.options));
      selectedOptionIndices[surveyKey] = null;
    }
  }


  @override
  Widget build(BuildContext context) {

    if (pages.isEmpty) {
      return Scaffold(
        appBar: BaumannTestAppBar(),
        body: const Center(
          child: Text('페이지가 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: BaumannTestAppBar(),
      body: baumannTestUI(),
    );
  }


  Widget baumannTestUI() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textUIs(),
        _btnType(),
      ],
    );
  }


  Widget _textUIs() {
    QuestionPage currentPageData = pages[currentPage];
    int? selectedOptionIndex = selectedOptionIndices[currentPageData.surveyKey];

    return ListTile(
      title: Text('문항 번호 : ${currentPageData.surveyKey}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('문제 : ${currentPageData.question}'),
          const Text('선택지 :'),
          Column(
            children: currentPageData.options.asMap().entries.map((entry) {
              int index = entry.key+1;
              Option option = entry.value;
              return RadioListTile(
                value: index,
                groupValue: selectedOptionIndex,
                onChanged: (int? value) {
                  setState(() {
                    selectedOptionIndices[currentPageData.surveyKey] = value;
                  });
                },
                title: Text('선택지 ${option.option} : ${option.description}'),
              );
            }).toList(),
          )
        ],
      ),
    );
  }


  Widget _btnType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (currentPage > 0 && currentPage != pages.length - 1) _prevBtn(),
        if (currentPage < pages.length - 1) _nextBtn(),
        if (currentPage == pages.length - 1) _resultBtn(),
      ],
    );
  }


  Widget _prevBtn() {
    return ElevatedButton(
      onPressed: previousPage,
      child: const Text('이전'),
    );
  }


  Widget _nextBtn() {
    return ElevatedButton(
      onPressed: nextPage,
      child: const Text('다음'),
    );
  }


  Widget _resultBtn() {
    return ElevatedButton(
      onPressed: () async {

        print('Selected Option Indices : ');
        selectedOptionIndices.forEach((key, value) {
          print('$key: ${value != null ? value + 1 : null}');
        });
        // 새로 추가한 함수 호출: 선택된 데이터를 백엔드로 보내기
        await sendSurveyToBackend(selectedOptionIndices);

        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BaumannResultPage()));
      },
      child: const Text('결과보기'),
    );
  }


  // 새로운 함수: 데이터를 백엔드로 전송
  Future<void> sendSurveyToBackend(Map<String, int?> surveyData) async {

    final url = Uri.http(Config.apiURL, Config.baumannTestAPI).toString();

    try {
      // JSON 데이터 생성
      final jsonData = {
        "responses": surveyData,
      };

      // 백엔드로 JSON 데이터 전송
      final response = await BaumannService.postJson(url, jsonData); //이게 안됨

      // 응답 처리
      if (response.statusCode == 200) {
        // 성공적으로 전송됨
        // 이후 결과 페이지로 이동하거나 다른 작업을 수행
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BaumannResultPage(resultData: response!)));
        print(response);

      } else {
        // 전송 실패 또는 오류 발생
        // 오류 메시지를 사용자에게 표시
        Fluttertoast.showToast(
          msg: '서버로 데이터를 전송하는 중 문제가 발생했습니다',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // 예외 처리
      print('An error occurred: $e');
    }
  }


  void nextPage() {
    int? selectedOptionIndex = selectedOptionIndices[pages[currentPage].surveyKey];

    if (selectedOptionIndex == null) {
      // 옵션이 선택되지 않았을 때 Toast 메시지 표시
      Fluttertoast.showToast(
        msg: '항목이 선택되지 않았습니다',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    else {
      setState(() {
        if (currentPage < pages.length - 1) {
          currentPage++;
        }
      });
    }
  }


  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

}


class QuestionPage {
  final String surveyKey;
  final String question;
  final List<Option> options;

  QuestionPage(this.surveyKey, this.question, this.options);
}
