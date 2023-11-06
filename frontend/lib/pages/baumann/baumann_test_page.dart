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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaumannTestAppBar(),
      body: ListView.builder(
        itemCount: widget.data?.surveys.length,
        itemBuilder: (context, index) {
          String surveyKey = widget.data.surveys.keys.elementAt(index);
          BaumannSurveys survey = widget.data.surveys[surveyKey]!;

          return ListTile(
            title: Text('Survey Key: $surveyKey'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question: ${survey.questionKr}'),
                Text('Options:'),
                Column(
                  children: survey.options.map((option) {
                    return Text('Option ${option.option}: ${option.description}');
                  }).toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
