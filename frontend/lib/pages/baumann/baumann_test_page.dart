import 'package:beautyminder/pages/baumann/baumann_result_page.dart';
import 'package:beautyminder/widget/baumannTestAppBar.dart';
import 'package:flutter/material.dart';
import 'package:beautyminder/dto/baumann_model.dart';

class BaumannTestPage extends StatefulWidget {
  const BaumannTestPage({Key? key, required this.data}) : super(key: key);

  final SurveyWrapper data;

  @override
  _BaumannTestPageState createState() => _BaumannTestPageState();
}

class _BaumannTestPageState extends State<BaumannTestPage> {

  int currentPage = 0; // 현재 페이지 인덱스
  List<QuestionPage> pages = [];
  List<int?> selectedOptionIndices = [];

  @override
  void initState() {
    super.initState();

    // 페이지 목록을 생성합니다.
    for (String surveyKey in widget.data.surveys.keys) {
      BaumannSurveys survey = widget.data.surveys[surveyKey]!;
      pages.add(QuestionPage(surveyKey, survey.questionKr, survey.options));
      selectedOptionIndices.add(null);
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
        _btnSort(),
      ],
    );
  }


  Widget _textUIs() {
    QuestionPage currentPageData = pages[currentPage];

    int? selectedOptionIndex = selectedOptionIndices[currentPage];

    return ListTile(
      title: Text('문항 번호 : ${currentPageData.surveyKey}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('문제 : ${currentPageData.question}'),
          const Text('선택지 :'),
          Column(
            children: currentPageData.options.asMap().entries.map((entry) {
              int index = entry.key;
              Option option = entry.value;
              return RadioListTile(
                  value: index,
                  groupValue: selectedOptionIndex,
                  onChanged: (int? value) {
                    setState(() {
                      selectedOptionIndices[currentPage] = value;
                    });
                  },
                title: Text('선택지 ${option.option} : ${option.description}'),
                // secondary: selectedOptionIndex == index ? Icon(Icons.check) : null,
              );
            }).toList(),
          )
        ],
      ),
    );
  }


  Widget _btnSort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (currentPage > 0 && currentPage != pages.length - 1)
          _prevBtn(),

        if (currentPage < pages.length - 1)
          _nextBtn(),

        if (currentPage == pages.length - 1)
          _resultBtn(),
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
      onPressed: () {
        print('Selected Option Indices : ');
        for (int i = 0; i < selectedOptionIndices.length; i++) {
          print('Question ${i + 1}: ${selectedOptionIndices[i]}');
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BaumannResultPage()));
        },
      child: const Text('결과보기'),
    );
  }


  void nextPage() {
    setState(() {
      if (currentPage < pages.length - 1) {
        currentPage++;
      }
    });
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
