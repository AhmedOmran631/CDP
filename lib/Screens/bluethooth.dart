import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class Bluethooth extends StatefulWidget {
  @override
  _BluethoothState createState() => _BluethoothState();
}

class _BluethoothState extends State<Bluethooth> {
  BluetoothConnection connection;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  StreamSubscription streamSubscription;
  List _connectedDevices = [];

  void startDiscovery() {
    streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      results.add(r);
      print(r.device.name);
    });

    streamSubscription.onDone(() {
      print("end scan");
    });
  }

  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
     
      connection.input.listen((Uint8List data) {
        print(ascii.decode(data));
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  Future send(String data) async {
    connection.output.add(utf8.encode(data));
    await connection.output.allSent;
    print(connection.output.toString());
  }

  Future<Null> _onRefresh() {
    setState(() {});
    return Future.delayed(Duration(seconds: 1));
  }

  _disconnect() {
    Future.delayed(Duration(seconds: 1)).then((_) async {
      await connection.close().then((_) {
        print("disconnected");
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = List<Container>();

    for (var r in results) {
      containers.add(
        Container(
            height: 70,
            child: ListTile(
              title:
                  Text(r.device.name == "" ? "UNKNOWN DEVICE" : r.device.name),
              subtitle: Text(r.device.address.toString()),
              trailing: _connectedDevices.contains(r.device)
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      RaisedButton(
                          color: Colors.cyan[800],
                          child: Text(
                            "DISCONNECT",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          onPressed: () async {
                            await connection.close().then((_) {
                              print("disconnect");
                            });
                          }),
                    ])
                  : RaisedButton(
                      color: Colors.cyan[800],
                      child: Text(
                        "CONNECT",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await connect(r.device.address).then((_) {
                          setState(() {
                        
                            _connectedDevices.add(r.device);
                          });
                        });
                        _disconnect();
                      },
                    ),
            )),
      );
    }

    return ListView(
      padding: EdgeInsets.all(8),
      children: containers
    );
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[800],
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 15),
                child: GestureDetector(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("SCAN     ")),
                  onTap: () {
                    FlutterBluetoothSerial.instance.state.then((state) {
                      if (state == BluetoothState.STATE_OFF) {
                        showDialog(
                            context: context,
                            builder: (contxt) => AlertDialog(
                                  shape: Border.all(color: Colors.cyan[800] ,width: 2.5),
                                  title: Text(
                                    "The Bluethooth is off !",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyan[800]),
                                  ),
                                  content: Text("please turn it On ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                ));
                      } else if (state == BluetoothState.STATE_ON) {
                        print("scanning");
                        startDiscovery();
                      }
                    });
                  },
                ))
          ],
        ),
        body: RefreshIndicator(
            color: Colors.cyan[800],
            key: _refreshIndicatorKey,
            onRefresh: _onRefresh,
            child: SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: _buildListViewOfDevices())));
  }
}
