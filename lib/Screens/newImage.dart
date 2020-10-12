import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;

class NewImage extends StatefulWidget {
  final Uint8List image;
  final String imageTitle;

  NewImage(this.image, this.imageTitle);
  @override
  _NewImageState createState() => _NewImageState();
}

class _NewImageState extends State<NewImage> {
  var _images;
  var _gCode;

  _getImage() async {
    String url = "http://192.168.88.224:4000/${widget.imageTitle}";
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    print(response.statusCode);
    print(response.body);
    //print(json.decode(response.body));

    setState(() {
      _gCode = json.decode(response.body);
      print(_gCode);
    });
  }

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  BluetoothConnection connection;

  Future send(String data) async {
    connection.output.add(utf8.encode(data));
    await connection.output.allSent;
    print(connection.output.toString());
  }

  var adress;
  @override
  void initState() {
    super.initState();
    setState(() {
      _images = widget.image;
    });
    _getImage();
    // .then((_){
    //   setState(() {
    //     _gCode;
    //   });
    // });

  

    BluetoothConnection.toAddress(adress).then((_connection) {
      print('Connected to the device');
      connection = connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyan[800]),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Stack(
            children: <Widget>[
              Center(
                  child: Container(
                
                child: _images != null
                    ? FadeInImage(
                        image: Image.memory(_images).image,
                        placeholder: AssetImage("assets/CDP.jpg"),
                      )
                    : Image.asset(
                        "assets/CDP.jpg",
                        fit: BoxFit.cover,
                      ),
              )),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                    color: Colors.cyan[800],
                    child: Text(
                      "SEND",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      send(_gCode);
                    }),
              ),
            ],
          )),
    );
  }
}
