import 'dart:async';

import 'package:beautyminder/pages/my/widgets/default_dialog.dart';
import 'package:beautyminder/pages/my/widgets/review/update_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> updatePopUp({
  required String title,
  required BuildContext context,
  String? subTitle,
  String? okBtnText,
  String? noBtnText,
}) {
  Completer<bool> completer = Completer();
  showDialog(
    context: context,
    builder: (context) => UpdateDialog(
      onBarrierTap: () {
        completer.complete(false);
        Navigator.of(context).pop();
      },
      title: title,
      body: subTitle,
      buttons: [
        UpdateDialogButton(
          onTap: () {
            completer.complete(false);
            Navigator.of(context).pop();
          },
          text: noBtnText ?? "취소",
          backgroundColor: const Color(0xFFF5F5F5),
          textColor: Colors.black,
        ),
        UpdateDialogButton(
          onTap: () {
            completer.complete(true);
            Navigator.of(context).pop();
          },
          text: okBtnText ?? "수정",
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        ),
      ],
    ),
  );

  return completer.future;
}
