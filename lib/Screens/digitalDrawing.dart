import 'dart:ui';

import 'package:drawing/Screens/sendGCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DigitalDrawing extends StatefulWidget {
  @override
  _DigitalDrawingState createState() => _DigitalDrawingState();
}

class _DigitalDrawingState extends State<DigitalDrawing> {
  List<Map<String, dynamic>> points = [];
  List<bool> pen = [];
  bool draw = true;
  List<String> allData = [];
  String data2 = "M300 S50.00 (pen up)"
      "\n"
      "G4 P150 (wait 150ms)"
      "\n";
  String data1 = "M300 S30.00 (pen down)"
      "\n"
      "G4 P150 (wait 150ms)"
      "\n";

  @override
  void initState() {
    pen.add(draw);
    super.initState();
    points = [
      {"offset": Offset(180, 390.0), "z": 1},
      {"offset": Offset(180, 390.0), "z": 1},
    ];
    allData.add(data1);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan[800],
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    pen.clear();
                    pen.add(true);
                    points.clear();
                    points = [
                      {"offset": Offset(width / 2, height / 2), "z": 1},
                      {"offset": Offset(width / 2, height / 2), "z": 1}
                    ];
                  });
                  allData.clear();
                  allData.add(data1);
                })
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  height: 120,
                  width: 125,
                  padding: EdgeInsets.only(
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan[800]),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                            top: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  padding: EdgeInsets.only(right: 10, top: 15),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    var value = points[points.length - 1];
                                    var dy =
                                        (5 / height) * (value["offset"].dy);
                                    var dx =
                                        (5 / width) * (value["offset"].dx - 5);

                                    if (draw) {
                                      points.add({
                                        "offset": Offset(value["offset"].dx - 5,
                                            value["offset"].dy),
                                        "z": 1
                                      });
                                      allData.add(
                                          "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                                          "\n");
                                    } else {
                                      points.add({
                                        "offset": Offset(value["offset"].dx - 5,
                                            value["offset"].dy),
                                        "z": 0
                                      });
                                    }
                                  }),
                              SizedBox(width: 15),
                              IconButton(
                                  padding: EdgeInsets.only(top: 15, left: 5),
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    var value = points[points.length - 1];
                                    var dy =
                                        (5 / height) * (value["offset"].dy);
                                    var dx =
                                        (5 / width) * (value["offset"].dx + 5);

                                    if (draw) {
                                      points.add({
                                        "offset": Offset(value["offset"].dx + 5,
                                            value["offset"].dy),
                                        "z": 1
                                      });
                                      allData.add(
                                          "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                                          "\n");
                                    } else {
                                      points.add({
                                        "offset": Offset(value["offset"].dx + 5,
                                            value["offset"].dy),
                                        "z": 0
                                      });
                                    }
                                  }),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 24),
                          child: Column(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    var value = points[points.length - 1];
                                    var dy =
                                        (5 / height) * (value["offset"].dy - 5);
                                    var dx = (5 / width) * (value["offset"].dx);
                                    if (draw) {
                                      points.add({
                                        "offset": Offset(value["offset"].dx,
                                            value["offset"].dy - 5),
                                        "z": 1
                                      });
                                      allData.add(
                                          "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                                          "\n");
                                    } else {
                                      points.add({
                                        "offset": Offset(value["offset"].dx,
                                            value["offset"].dy - 5),
                                        "z": 0
                                      });
                                    }
                                  }),
                              SizedBox(height: 15),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    var value = points[points.length - 1];
                                    var dy =
                                        (5 / height) * (value["offset"].dy + 5);
                                    var dx = (5 / width) * (value["offset"].dx);
                                    if (draw) {
                                      points.add({
                                        "offset": Offset(value["offset"].dx,
                                            value["offset"].dy + 5),
                                        "z": 1
                                      });
                                      allData.add(
                                          "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                                          "\n");
                                    } else {
                                      points.add({
                                        "offset": Offset(value["offset"].dx,
                                            value["offset"].dy + 5),
                                        "z": 0
                                      });
                                    }
                                  }),
                            ],
                          ))
                    ],
                  )),
              Container(
                  height: 120,
                  width: 95,
                  padding: EdgeInsets.only(
                    right: 18,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan[800]),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_upward,
                              size: 50, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              draw = false;
                              pen.add(false);

                              allData.add(data2);
                              allData.add("\n");
                              allData.add("\n");
                            });
                          }),
                      SizedBox(height: 10),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_downward,
                            size: 50,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              draw = true;
                              pen.add(true);
                              allData.add(data1);
                            });
                          }),
                    ],
                  ))
            ],
          ),
        ),
        body: SafeArea(
            minimum: EdgeInsets.only(right: 5, left: 10, bottom: 30),
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  painter: OpenPainter(points: points, draw: draw),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 45,
                      width: 45,
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.cyan[800]),
                    )),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        padding: EdgeInsets.only(right: 20, top: 15),
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          if (pen[pen.length - 1] == true) {
                            allData.add(data2);
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendGCode(
                                      reformData: allData.join().toString())));
                        }))
              ],
            )));
  }
}

class OpenPainter extends CustomPainter {
  List points;
  bool draw;

  OpenPainter({
    this.points,
    this.draw,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    var paint2 = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i]["z"] == 1) {
        canvas.drawLine(points[i]["offset"], points[i + 1]["offset"], paint1);
      } else if (points[i]["z"] == 0) {
        canvas.drawLine(points[points.length - 1]["offset"],
            points[points.length - 1]["offset"], paint2);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}
