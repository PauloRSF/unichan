import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primarySwatch: Colors.red,
    primaryColor: Color(0xff202020),
    backgroundColor: Color(0xff202020),
    indicatorColor: Color(0xff0E1D36),
    buttonColor: Color(0xff3B3B3B),
    hintColor: Color(0xff280C0B),
    highlightColor: Color(0xff372901),
    hoverColor: Color(0xff3A3A3B),
    focusColor: Color(0xff0B2512),
    disabledColor: Colors.grey,
    textSelectionColor: Colors.white,
    cardColor: Color(0xFF151515),
    canvasColor: Color(0xff202020),
    brightness: Brightness.dark,
    //buttonTheme: Theme.of(context).buttonTheme.copyWith(
    //    colorScheme: ColorScheme.dark()
    //),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}