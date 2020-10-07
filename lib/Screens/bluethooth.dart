import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
var _address = "";

// ignore: must_be_immutable
class Bluethooth extends StatefulWidget {
   BluetoothDevice device;
  var adress = _address;

  @override
  _BluethoothState createState() => _BluethoothState();
}

class _BluethoothState extends State<Bluethooth> {
 // var scanSubscription;

 var deviceConnection;
 
 BluetoothConnection connection;
List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
StreamSubscription streamSubscription;
List _connectedDevices = [];

  void startDiscovery() {
    streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {  
        //  if (!results.contains(r) ) {
        results.add(r);
        print(r.device.name);
     // }
    });

    streamSubscription.onDone(() {
      print("end scan");
    });
  }



  connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      setState(() {

        _address = address;
      });

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
    return Future.delayed(Duration(seconds: 2));
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
              leading: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // var data = utf8.encode("f");
                    send("string");
                  }),
              title:
                  Text(r.device.name == "" ? "UNKNOWN DEVICE" : r.device.name),
              subtitle: Text(r.device.address.toString()),
              trailing: _connectedDevices.contains(r.device)
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      RaisedButton(
                          color: Colors.cyan[800],
                          child: Text(
                            "DISCONNECT",
                            style: TextStyle(fontSize: 13),
                          ),
                          onPressed: () async {
                        
                        // ignore: deprecated_member_use
                        await  FlutterBluetoothSerial.instance.disconnect();
                      
                            // await device.disconnect().then((_) {
                            //   print("disconnect");
                            // });

                            // connectedDevices.clear();
                          }),
                   
                    ])
                  : RaisedButton(

                      color: Colors.cyan[800],
                      child: Text("CONNECT"),
                      onPressed: () async {
                        connect(r.device.address);
              
                        setState(() {
                        _address = r.device.address;
                        
                           _connectedDevices.add(r.device);
                        
                        });
                      
                      },
                    ),
             
            )),
      );
    }

    return ListView(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        // ignore: sdk_version_ui_as_code
        ...containers,
      ],
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
                  child: Center(child: Text("SCAN")),
                  onTap: () {
                    print("scanning");

                   startDiscovery();
                   //connect(_address);
                 
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
