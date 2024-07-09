import 'package:konter_hp/views/main_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// import 'package:/views/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(99, 15, 255, 1),
      body: Center(
        child: Image.asset(
          'assets/icons/icon.png',
          width: 400,
        ),
      ),
    );
  }
}
