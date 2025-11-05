import 'package:flutter/material.dart';
import 'package:kisanview1/screens_intro/intro_screen_1.dart';
import 'package:kisanview1/screens_intro/intro_screen_2.dart';
import 'package:kisanview1/screens_intro/intro_screen_3.dart';
import 'package:kisanview1/screens_intro/intro_screen_4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
           // give PageView some space
           width: double.infinity,
            child: PageView(
              children: [
                IntroScreen1(),
                IntroScreen2(),
                IntroScreen3(),
                IntroScreen4(),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
