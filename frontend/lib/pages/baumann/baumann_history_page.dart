
import 'package:beautyminder/dto/baumann_model.dart';
import 'package:beautyminder/pages/baumann/baumann_test_start_page.dart';
import 'package:beautyminder/pages/baumann/watch_result_page.dart';
import 'package:beautyminder/pages/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kg_charts/kg_charts.dart';

import '../../dto/baumann_result_model.dart';
import '../../services/api_service.dart';
import '../../services/baumann_service.dart';
import '../../widget/commonAppBar.dart';
import 'baumann_result_page.dart';

class BaumannHistoryPage extends StatefulWidget {
  const BaumannHistoryPage({Key? key, required this.resultData}) : super(key: key);

  final List<BaumannResult>? resultData;

  @override
  _BaumannHistoryPageState createState() => _BaumannHistoryPageState();
}

class _BaumannHistoryPageState extends State<BaumannHistoryPage> {

  @override
  Widget build(BuildContext context) {
    print("This is History Page : ${widget.resultData}");
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [_baumannHistoryUI(),
          ],
        )
      ),
    );
  }

  Widget _baumannHistoryUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left-align the text
      children: [
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.only(left: 20), // Add left padding
          child: Text(
            "바우만 피부 타입 결과",
            style: TextStyle(
              color: Color(0xFF868383), // Set text color to grey
              fontSize: 15, // Adjust font size as needed
            ),
          ),
        ),
        _divider(),
        _baumannHistoryListView(),
      ],
    );
  }

  Widget _baumannHistoryListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.resultData?.length ?? 0,
      itemBuilder: (context, index) {
        final result = widget.resultData![index];
        final isEven = index.isEven;

        return Column(
          children: [
            SizedBox(height: 5),
            _resultButton(result, isEven),
          ],
        );
      },
    );
  }

  Widget _resultButton(BaumannResult result, bool isEven) {
    Color buttonColor = isEven ? Colors.white : Color(0xffffb876);
    Color textColor = isEven ? Colors.black : Colors.white;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WatchResultPage(resultData: result)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor, // 버튼의 배경색을 회색으로 변경
            side: BorderSide(color: Color(0xffffb876)),
            elevation: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('피부타입: ${result.baumannType}', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(width: 16),
                  Text('테스트 일시: ${result.date}', style: TextStyle(color: textColor, fontSize: 18),),
                ],
              ),
              //
              _baumannResultContent(result, isEven),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baumannResultContent(BaumannResult result, bool isEven) {
    Color cardColor = isEven ? Colors.white : Color(0xffffb876);
    Color textColor = isEven ? Color(0xff6e6e6e) : Colors.white;

    // Baumann Result에 대한 정보를 나타내는 Card 위젯
    return Card(
      // margin: EdgeInsets.all(10),
      color: cardColor,
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            subtitle: Column(
              children: [
                SizedBox(height: 5),
                Text('색소침착도: ${result.baumannScores['pigmentation']}/57', style: TextStyle(color: textColor),),
                Text('유수분 밸런스: ${result.baumannScores['hydration']}/44', style: TextStyle(color: textColor)),
                Text('탄력: ${result.baumannScores['elasticity']}/85', style: TextStyle(color: textColor)),
                Text('수분 보유력: ${result.baumannScores['moistureRetention']}/65', style: TextStyle(color: textColor)),
                Text('민감도: ${result.baumannScores['sensitivity']}/64', style: TextStyle(color: textColor)),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 20,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey,
    );
  }

}