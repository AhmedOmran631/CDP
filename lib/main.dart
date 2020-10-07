import 'package:drawing/Screens/OptionsScreen.dart';
import 'package:drawing/Screens/bluethooth.dart';
import 'package:drawing/Screens/digitalDrawing.dart';
import 'package:drawing/Screens/firstScreen.dart';
import 'package:drawing/Screens/handDrawing.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/HandDrawing': (context) => HandDrawing(),
          '/DigitalDrawing': (context) => DigitalDrawing(),
          '/OptionsScreen': (context) => OptionsScreen(),
          '/Bluethooth': (context) => Bluethooth(),
        },
        home: FirstScreen());
  }
}
