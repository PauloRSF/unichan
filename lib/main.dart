import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'theme/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniChan',
      theme: appTheme(),
      home: Home(),
    );
  }
}
