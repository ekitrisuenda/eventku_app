import 'package:flutter/material.dart';
import 'dart:async';
import 'package:eventku_app/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    starSplashScreen();
  }

  starSplashScreen()async{
    var duration = const Duration(seconds: 5);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_){
          return Login();
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/Untitled-1.png',
              width: 200.0,
              height: 100.0,
            ),
            Text('Kunci kesuksesan sebuah event.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: 15, ),),
          ],
        ),

      ),
    );
  }
}
