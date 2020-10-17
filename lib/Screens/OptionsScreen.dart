import 'dart:io';

import 'package:drawing/Screens/input_image/image_input.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing control program"),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        leading: FlatButton(
            child: Icon(
              Icons.bluetooth_connected,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/Bluethooth");
            }),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // _option(),
              // SizedBox(height: 10),
              // _option2(),
              SizedBox(height: 5),
              ImageInput(_setImage, _image)
            ],
          ))),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: Image.asset("assets/hand.png"),
              title: new Text("Hand Drawing")),
          new BottomNavigationBarItem(
              icon: Image.asset("assets/arrows.png"),
              title: new Text("Digital Drawing")),
          new BottomNavigationBarItem(
       
             icon: new Icon(Icons.photo), title: new Text("Import photo")),
        ],
        backgroundColor: Colors.white,
        onTap: (int index) => index == 0
            ? Navigator.pushNamed(context, "/HandDrawing")
            : index == 1
                ? Navigator.pushNamed(context, "/DigitalDrawing")
                : ImageInput(_setImage, _image),
      ),
    );
  }

  // Widget _option() {
  //   return GestureDetector(
  //       onTap: () {
  //         Navigator.pushNamed(context, "/HandDrawing");
  //       },
  //       child: Stack(
  //         children: <Widget>[
  //           Container(
  //               alignment: Alignment.centerLeft,
  //               margin: EdgeInsets.only(left: 65, top: 10),
  //               width: 200,
  //               height: 65,
  //               decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: Colors.deepOrangeAccent, width: 3),
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Colors.white),
  //               child: Center(
  //                 child: Text(
  //                   "Hand Drawing",
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //               )),
  //           Container(
  //               width: 90,
  //               height: 85,
  //               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //               decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: Colors.deepOrangeAccent, width: 3),
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Colors.white),
  //               child: RotationTransition(
  //                   turns: AlwaysStoppedAnimation(-50 / 360),
  //                   child: Image.asset("assets/hand.png"))),
  //         ],
  //       ));
  // }

  // Widget _option2() {
  //   return GestureDetector(
  //       onTap: () {
  //         Navigator.pushNamed(context, "/DigitalDrawing");
  //       },
  //       child: Stack(
  //         children: <Widget>[
  //           Container(
  //               alignment: Alignment.centerLeft,
  //               margin: EdgeInsets.only(left: 65, top: 10),
  //               width: 200,
  //               height: 65,
  //               decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: Colors.deepOrangeAccent, width: 3),
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Colors.white),
  //               child: Center(
  //                 child: Text(
  //                   "Digital Drawing",
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //               )),
  //           Container(
  //               width: 90,
  //               height: 85,
  //               padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
  //               decoration: BoxDecoration(
  //                   border:
  //                       Border.all(color: Colors.deepOrangeAccent, width: 3),
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Colors.white),
  //               child: RotationTransition(
  //                   turns: AlwaysStoppedAnimation(-45 / 360),
  //                   child: Image.asset("assets/arrows.png"))),
  //         ],
  //       ));
  // }

  _setImage({File image}) {
    setState(() async {
      _image = image;
    });
  }
}
