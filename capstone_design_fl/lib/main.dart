import 'package:capstone_design_fl/src/Widget/bottomnavi.dart';
import 'package:capstone_design_fl/src/homePage.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:capstone_design_fl/src/welcomPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'BeautyMinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
        //   bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      home: bottomnavi(),
    );
  }
}