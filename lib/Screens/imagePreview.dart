import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drawing/Screens/newImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImagePreview extends StatefulWidget {
  final File image;

  ImagePreview(this.image);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  String imageTitle;
  List<int> value1;
  List<int> value2;
  List<int> value3;
  _readBytes() async {
    ByteData starValue = await rootBundle.load("assets/Star.png");
    ByteData squareValue = await rootBundle.load("assets/Square.png");
    ByteData chessValue = await rootBundle.load("assets/3D_Chessboard.png");
    setState(() {
      value1 = starValue.buffer.asUint8List();
      value2 = squareValue.buffer.asUint8List();
      value3 = chessValue.buffer.asUint8List();
    });
  }

  List<Map<String, dynamic>> imagesValue = [];

  var _image;

  _sendImage(File image) async {
    String url = "http://192.168.88.224:4000/upload";

    http.Response response = await http.post(url,
        headers: {
          "Accept": "application/json",
          //"Content-Type":"charset=utf-8"
        },
        body: json.encode({"Image": image.path}));
    print(image.path);
    print(response.statusCode);
    //print(json.decode(response.body));
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _image = response.bodyBytes;

        print(_image);
      });
    }
  }

  var _value;
  _checkImage() async {
    ByteData image = await rootBundle.load(widget.image.path);
    _value = image.buffer.asUint8List();

    for (int i = 0; i < imagesValue.length; i++) {
      if (imagesValue[i].containsValue(_value.toString())) {
        print(imagesValue[i].keys);
        setState(() {
          imageTitle = imagesValue[i].keys.toString();
        });
      }
    }
  }

  _init() async {
    await _readBytes().then((_) {
      setState(() {
        imagesValue = [
          {"Star": value1.toString()},
          {"Square": value2.toString()},
          {"3D_Chessboard": value3.toString()},
        ];
      });
    });
    await _checkImage();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text(
            path.basename(widget.image.path),
            style: TextStyle(fontSize: 14),
          )),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                    child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                )),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                    color: Colors.lightBlue,
                    child: Text(
                      "SEND",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (imageTitle != null) {
                        var last = imageTitle.length;

                        await _sendImage(widget.image);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewImage(
                                    _image,
                                    imageTitle
                                        .substring(1, last - 1)
                                        .toString())));
                      } else {
                        showDialog(
                            context: context,
                            builder: (contxt) => AlertDialog(
                                  title: Text(
                                    "Somthing Went Wrong !",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  content: Text(
                                      "please try with another picture",
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                ));
                      }
                    }),
              ),
            ],
          )),
    );
  }
}
