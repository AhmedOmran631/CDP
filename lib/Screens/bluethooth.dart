import 'dart:async';
import 'dart:convert';
//import 'dart:typed_data';

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
  // List _connectedDevices = [];
  String _connectdevice = "";
  bool scan = false;

  Icon findBluet = Icon(
    Icons.search,
    color: Colors.white,
    size: 35,
  );

  bool _finddevicesinlist(BluetoothDevice device) {
    for (var r in results) {
      if (r.device == device) return false;
    }
    return true;
  }

  void startDiscovery() {
    streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      findBluet = Icon(
        Icons.stop,
        color: Colors.red,
        size: 35,
      );

      if (r != null) if (_finddevicesinlist(r.device)) results.add(r);

      print(r.device.name);
    });
    // Future.delayed(Duration(seconds: 4));
    streamSubscription.onDone(() {
      findBluet = Icon(
        Icons.search,
        color: Colors.white,
        size: 35,
      );
      print("end scan");
    });
  }

  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');

      // connection.input.listen((Uint8List data) {
      //   print(ascii.decode(data));
      // });
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
    return Future.delayed(Duration(seconds: 4));
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
    print(results.length);
    if (results.length > 0) {
      for (var r in results) {
        containers.add(
          Container(
              height: 70,
              child: ListTile(
                title: Text(r.device.name != null
                    ? r.device.name == "" ? "UNKNOWN DEVICE" : r.device.name
                    : ""),
                subtitle: Text(r.device.name != null
                    ? r.device.address == ""
                        ? "UNKNOWN DEVICE"
                        : r.device.address.toString()
                    : ""),
                trailing: _connectdevice == r.device.address.toString()
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        RaisedButton(
                            color: Colors.lightBlue,
                            child: Text(
                              "DISCONNECT",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            onPressed: () async {
                              await connection.close().then((_) {
                                print("disconnect");
                              });
                            }),
                      ])
                    : r.device.name != null
                        ? RaisedButton(
                            color: Colors.lightBlue,
                            child: Text(
                              "CONNECT",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await connect(r.device.address).then((_) {
                                setState(() {
                                  // if (_finddevicesinlist(r.device))
                                  // _connectedDevices.add(r.device);
                                  // _connectdevice=r.device;
                                  _connectdevice = r.device.address.toString();
                                  print(r.device);
                                });
                              });
                              _disconnect();
                            },
                          )
                        : Text(
                            "",
                          ),
              )),
        );
      }
    } else {
      if (scan) {
        containers.add(
          Container(
            height: 70,
            child: Text("There are no devices to display"),
          ),
        );
      }
    }

    return ListView(padding: EdgeInsets.all(8), children: containers);
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Align(
            alignment: Alignment.center,
            child: Text('Find Devices'),
          )),
      body: RefreshIndicator(
        color: Colors.lightBlue,
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: _buildListViewOfDevices()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlutterBluetoothSerial.instance.state.then((state) {
              if (state == BluetoothState.STATE_OFF) {
                showDialog(
                    context: context,
                    builder: (contxt) => AlertDialog(
                          shape:
                              Border.all(color: Colors.lightBlue, width: 2.5),
                          title: Text(
                            "The Bluethooth is off !",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                          content: Text("please turn it On ",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                        ));
              } else if (state == BluetoothState.STATE_ON) {
                print("------------------>>  scanning");
                startDiscovery();
                scan = true;
              }
            });
          },
          child: findBluet),
    );
  }
}
