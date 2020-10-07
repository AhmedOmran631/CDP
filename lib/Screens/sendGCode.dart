import 'dart:convert';
import 'dart:typed_data';

import 'package:drawing/Screens/bluethooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SendGCode extends StatefulWidget {
  final String reformData;
  //final BluetoothDevice device;
  SendGCode({
    this.reformData,
  });
  @override
  _SendGCodeState createState() => _SendGCodeState();
}

class _SendGCodeState extends State<SendGCode> {
  bool isConnecting = true;
  
  String _data;

  BluetoothConnection connection;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  Future send(String data) async {
    // connection.output.add(utf8.encode(data));
    // await connection.output.allSent;
    connection.output.add(utf8.encode(data));
    await connection.output.allSent;
    print(connection.output.toString());
  }

  var adress;
  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      // setState(() {
      //   //widget.adress = address;
      // //  _adress = address;
      // });
      connection.input.listen((Uint8List data) {
        //Data entry point
        print(ascii.decode(data));
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  

  List line = [];

  _c() async {
    await BluetoothConnection.toAddress(Bluethooth().adress)
        .then((_connection) {
      print('Connected to the device');
      connection = connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _data = "G21 (metric ftw) "
            "\n"
            "G90 (absolute mode) "
            "\n"
            "G92 X0.00 Y0.00 Z0.00 (you are here)"
            "\n"
            "M300 S30 (pen down)"
            "\n"
            "G4 P150 (wait 150ms)"
            "\n "
            "M300 S50 (pen up)"
            "\n"
            "G4 P150 (wait 150ms)"
            "\n"
            "M18 (disengage drives)"
            "\n"
            "M01 (Was registration test successful?)"
            "\n"
            "M17 (engage drives if YES, and continue)"
            "\n" +
        "\n" +
        widget.reformData +
        "\n" +
        "  (end of print job)"
            "\n"
            "M300 S50.00 (pen up)"
            "\n"
            "G4 P150 (wait 150ms)"
            "\n"
            "M300 S255 (turn off servo)"
            "\n"
            "G1 X0 Y0 F3500.00"
            "\n"
            "G1 Z0.00 F150.00 (go up to finished level)"
            "\n"
            "G1 X0.00 Y0.00 F3500.00 (go home)"
            "\n"
            "M18 (drives off)"
            "\n";

    //  Bluethooth().adress != null
    //     ? adress = Bluethooth().adress
    //     : adress = "";

    _c();

    //  BluetoothConnection.toAddress(adress).then((_connection) {
    //   print('Connected to the device');
    //   connection = _connection;
    //   setState(() {
    //     isConnecting = false;
    //     isDisconnecting = false;
    //   });
    // });
  }

  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan[800],
        ),
        body: Center(
            child: RaisedButton(
                color: Colors.cyan[800],
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Text(
                  "SEND",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  print(adress);

                  await connect(adress);
                  //  send("false");

                  for (int i = 0; i < _data.length; i++) {
                    if (_data[i] != "\n") {
                      line.add(_data[i]);
                    } else if (_data[i] == "\n") {
                      print(line.join().toString());
                      send(line.join().toString());

                      line.clear();
                    }
                  }
                  // for(int j=0;j<_lines.length;j++){
                  //     for( int i=0;i<_data.length;i++){
                  //       if(_data[i] != _lines[j]){

                  //          line.add(_data[i]);

                  //        }

                  // }
                  //    send(line.join().toString());
                  //  print(line.join().toString());

                  //         send( _data);

                  // print(_data);
                  // }
                  //  print("10"+line.join().toString());
                })
            //  Text(_data)
            )
        // ]),
        );
  }
}
