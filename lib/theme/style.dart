import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Color(0xFF27242D),
    backgroundColor: Color(0xFF18151E),
   	textTheme: TextTheme(bodyText2: TextStyle(color: Color(0xFFDDDDDD))),
    canvasColor: Color(0xFF18151E),
    appBarTheme: AppBarTheme(color: Color(0xFF27242D)),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}