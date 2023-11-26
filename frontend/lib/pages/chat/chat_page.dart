import 'package:beautyminder/widget/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config.dart';
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ChatPage extends StatelessWidget {
  final String api;
  late final WebViewController controller;

  ChatPage({Key? key})
      : api = Config.apiURL + Config.chatAPI,
        super(key: key) {
    // Initialize the controller here
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(api));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(), body: WebViewWidget(controller: controller));
  }
}

