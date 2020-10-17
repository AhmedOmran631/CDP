import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SendGCode extends StatefulWidget {
  final String reformData;
  SendGCode({
    this.reformData,
  });
  @override
  _SendGCodeState createState() => _SendGCodeState();
}

class _SendGCodeState extends State<SendGCode> {
  String hc_16 = "20:19:03:28:15:55";
  String _data;
  bool isConnecting = true;

  BluetoothConnection connection;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  Future send(String data) async {
    connection.output.add(utf8.encode(data));
    await connection.output.allSent;
    print(connection.output.toString());
  }

  var adress;
  bool connected = false;
  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      connected = true;
      connection.input.listen((Uint8List data) {
        print(ascii.decode(data));
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  List line = [];

  List results = [];
  StreamSubscription streamSubscription;

  void startDiscovery() {
    print("star");
    streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      results.add(r.device.address);
      print(r.device.name);
    });

    streamSubscription.onDone(() {
      setState(() {
        connected = true;
      });
      print("end scan");
    });
  }

  _disconnect() {
    Future.delayed(Duration(seconds: 2)).then((_) async {
      await connection.close().then((_) {
        print("disconnected");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.reformData.length);
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

    startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
            child: connected
                ? RaisedButton(
                    color: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: Text(
                      "SEND",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () async {
                      print(hc_16);

                      if (results.contains(hc_16)) {
                        await connect(hc_16);

                        for (int i = 0; i < _data.length; i++) {
                          if (_data[i] != "\n") {
                            line.add(_data[i]);
                          } else if (_data[i] == "\n") {
                            print(line.join().toString());
                            send(line.join().toString());

                            line.clear();
                          }
                        }
                        results.clear();
                        _disconnect();
                      } else {
                        startDiscovery();
                      }
                    })
                : Center(
                    child: SpinKitFadingCircle(
                    color: Colors.lightBlue,
                    size: 28,
                  ))));
  }
}
