import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWillPopScope extends StatelessWidget {
  const CustomWillPopScope({
    required this.child,
    this.canPop = true,
    Key? key,
    required this.action,
  }) : super(key: key);

  final Widget child;
  final bool canPop;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < 0 ||
            details.velocity.pixelsPerSecond.dx > 0) {
          if (canPop) {
            action();
          }
        }
      },
      child: PopScope(
        canPop: canPop,
        onPopInvoked: (didPop) {
          if (!didPop && canPop) {
            action();
          }
        },
        child: child,
      ),
    )
        : PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) {
          action();
        }
      },
      child: child,
    );
  }
}
