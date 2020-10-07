import 'dart:ui';

import 'package:drawing/Screens/sendGCode.dart';
import 'package:flutter/material.dart';

class HandDrawing extends StatefulWidget {
  @override
  _HandDrawingState createState() => _HandDrawingState();
}

class _HandDrawingState extends State<HandDrawing> {
  List<DrawingPoints> points = [];
  List<bool> pen = [];

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[800],
          elevation: 0,
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

                    allData.clear();
                    allData.add(data1);
                  });
                })
          ],
        ),
        body: Stack(children: <Widget>[
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject();
                points.add(DrawingPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeWidth = 5
                      ..isAntiAlias = true
                      ..strokeCap = StrokeCap.round));
                var dx = (5 / width) *
                    (renderBox.globalToLocal(details.globalPosition).dx);
                var dy = (5 / height) *
                    renderBox.globalToLocal(details.globalPosition).dy;
                allData.add(
                    "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                    "\n");
              });
            },
            onPanStart: (details) {
              setState(() {
                pen.add(true);
                RenderBox renderBox = context.findRenderObject();
                points.add(DrawingPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()..isAntiAlias = true));

                var dx = (5 / width) *
                    (renderBox.globalToLocal(details.globalPosition).dx);
                var dy = (5 / height) *
                    renderBox.globalToLocal(details.globalPosition).dy;
                allData.add(data1);
                allData.add(
                    "G1 X${dx.toStringAsFixed(2)} Y${dy.toStringAsFixed(2)} F3500.00"
                    "\n");
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null);
                allData.add(data2);
                allData.add("\n");
                allData.add("\n");
                pen.add(false);
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(
                pointsList: points,
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 10, right: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.cyan[800]),
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  padding: EdgeInsets.only(bottom: 25, right: 20),
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    print(allData.join().toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendGCode(
                                reformData: allData.join().toString())));
                  }))
        ]));
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.lines, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}
