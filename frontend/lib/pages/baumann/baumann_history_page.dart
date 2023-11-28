import 'package:beautyminder/pages/baumann/baumann_test_start_page.dart';
import 'package:beautyminder/pages/baumann/watch_result_page.dart';
import 'package:flutter/material.dart';

import '../../dto/baumann_result_model.dart';
import '../../widget/commonAppBar.dart';

class BaumannHistoryPage extends StatelessWidget {
  final List<BaumannResult>? resultData;

  const BaumannHistoryPage({Key? key, required this.resultData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("This is History Page : $resultData");
    return Scaffold(
      appBar: CommonAppBar(),
      body: Column(
        children: [
          _baumannHistoryUI(),
          _divider(),
          _retestButton(context),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: _baumannHistoryListView(),
          ),
        ],
      ),
    );
  }

  Widget _baumannHistoryUI() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "바우만 피부 타입 결과",
              style: TextStyle(
                color: Color(0xFF868383),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _baumannHistoryListView() {
    return ListView.builder(
      itemCount: resultData?.length ?? 0,
      itemBuilder: (context, index) {
        final result = resultData![index];
        final isEven = index.isEven;

        return Column(
          children: [
            SizedBox(height: 5),
            _resultButton(context, result, isEven),
          ],
        );
      },
    );
  }

  // Widget _resultButton(BuildContext context, BaumannResult result, bool isEven) {
  //   Color buttonColor = isEven ? Colors.white : Color(0xffffca97);
  //   Color textColor = isEven ? Colors.black : Colors.white;
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     child: Container(
  //       height: 100,
  //       margin: EdgeInsets.symmetric(vertical: 5),
  //       child: ElevatedButton(
  //         onPressed: () {
  //           Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => WatchResultPage(resultData: result)));
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: buttonColor,
  //           side: BorderSide(color: Color(0xffffca97)),
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text('피부타입: ${result.baumannType}',
  //                     style: TextStyle(
  //                         color: textColor,
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold)),
  //                 SizedBox(width: 16),
  //                 Text('일시: ${result.date}',
  //                     style: TextStyle(color: textColor, fontSize: 12)),
  //               ],
  //             ),
  //             // _baumannResultContent(result, isEven),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _resultButton(BuildContext context, BaumannResult result, bool isEven) {
    Color buttonColor = isEven ? Colors.white : Color(0xffffca97);
    Color textColor = isEven ? Colors.black : Colors.white;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: AlignmentDirectional.centerEnd,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          // Implement your delete logic here
          print("HelloHelloHello");

          // Remove the dismissed item from the data source
          resultData?.remove(result);

          // Show a snackbar to undo the delete action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("삭제되었습니다."),
              action: SnackBarAction(
                label: "취소",
                onPressed: () {
                  // Undo the delete action
                  resultData?.insert(resultData!.indexOf(result), result);
                },
              ),
            ),
          );
        },
        confirmDismiss: (direction) async {
          // Show a confirmation dialog before deleting
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("정말로 삭제하시겠습니까?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Dismiss the dialog and reject the delete
                    },
                    child: Text("취소"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Dismiss the dialog and confirm the delete
                    },
                    child: Text("삭제"),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WatchResultPage(resultData: result)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              side: BorderSide(color: Color(0xffffca97)),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('피부타입: ${result.baumannType}',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 16),
                    Text('일시: ${result.date}',
                        style: TextStyle(color: textColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _retestButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BaumannStartPage(),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffefefef), // Background color
              elevation: 0, // color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                side: BorderSide(color: Colors.blueGrey),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Text(
                '다시 테스트하기',
                style: TextStyle(
                  color: Colors.blueGrey, // Text color
                ),
              ),
            ),
          ),
        ),
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
