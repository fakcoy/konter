import 'package:konter_hp/views/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:konter_hp/views/splash_screen.dart';

void main() {
  runApp(konter_hp());
}

class konter_hp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'konter_hp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
