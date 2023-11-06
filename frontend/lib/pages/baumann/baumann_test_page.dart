import 'package:beautyminder/pages/baumann/baumann_result_page.dart';
import 'package:beautyminder/widget/baumannTestAppBar.dart';
import 'package:flutter/material.dart';
import 'package:beautyminder/dto/baumann_model.dart';

class BaumannTestPage extends StatefulWidget {
  BaumannTestPage({required this.data});

  final SurveyWrapper data;

  @override
  _BaumannTestPageState createState() => _BaumannTestPageState();
}

class _BaumannTestPageState extends State<BaumannTestPage> {
  int currentPage = 0; // 현재 페이지 인덱스
  List<QuestionPage> pages = [];

  @override
  void initState() {
    super.initState();

    // 페이지 목록을 생성합니다.
    for (String surveyKey in widget.data.surveys.keys) {
      BaumannSurveys survey = widget.data.surveys[surveyKey]!;
      pages.add(QuestionPage(surveyKey, survey.questionKr, survey.options));
    }
  }

  @override
  Widget build(BuildContext context) {

    if (pages.isEmpty) {
      return Scaffold(
        appBar: BaumannTestAppBar(),
        body: Center(
          child: Text('페이지가 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: BaumannTestAppBar(),
      body: baumannTestUI(),
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


  Widget baumannTestUI() {

    QuestionPage currentPageData = pages[currentPage];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Survey Key: ${currentPageData.surveyKey}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question: ${currentPageData.question}'),
              Text('Options:'),
              Column(
                children: currentPageData.options.map((option) {
                  return Text('Option ${option.option}: ${option.description}');
                }).toList(),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (currentPage > 0 && currentPage != pages.length - 1)
              ElevatedButton(
                onPressed: previousPage,
                child: Text('이전'),
              ),
            if (currentPage < pages.length - 1)
              ElevatedButton(
                onPressed: nextPage,
                child: Text('다음'),
              ),
            if (currentPage == pages.length - 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BaumannResultPage()));
                },
                child: Text('결과보기'),
              ),
          ],
        ),
      ],
    );
}

}

class QuestionPage {
  final String surveyKey;
  final String question;
  final List<Option> options;

  QuestionPage(this.surveyKey, this.question, this.options);
}
