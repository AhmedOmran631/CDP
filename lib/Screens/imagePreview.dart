import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drawing/Screens/newImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

  List<Map<String, dynamic>> imagesValue;

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

  _checkImage(dynamic path) {
    for (int i = 0; i < imagesValue.length; i++) {
      if (imagesValue[i].containsValue(path.toString())) {
        print(imagesValue[i].keys);
        setState(() {
          imageTitle = imagesValue[i].keys.toString();
        });
      } else {}
    }
  }
// var _value;
//   _check() async {
//     ByteData image = await rootBundle.load(widget.image.path);
//     var value = image.buffer.asUint8List();
//   setState(() {
//     _value = value;
//   });
//   //  _checkImage(value);
//   }

  @override
  void initState() {
    super.initState();

    _readBytes();
    //  _check();
    // .then((_){
    //   _checkImage(_value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      imagesValue = [
        {"Star": value1.toString()},
        {"Square": value2.toString()},
        {"3D_Chessboard": value3.toString()},
      ];
    });
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyan[800]),
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
                    color: Colors.cyan[800],
                    child: Text(
                      "SEND",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      ByteData image = await rootBundle.load(widget.image.path);
                      var value = image.buffer.asUint8List();

                      await _checkImage(value.toString());

                      var last = imageTitle.length;
                      print(imageTitle.substring(1, last - 1));
                      if (imageTitle != null) {
                        //await _sendImage(widget.image);

                        //   if( _statusCode == 200 || _statusCode == 201){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewImage(
                                    _image,
                                    imageTitle
                                        .substring(1, last - 1)
                                        .toString())));
                        //  }

                      } else {
                        showDialog(
                            context: context,
                            builder: (contxt) => AlertDialog(
                                  title: Text(
                                    "Somthing Went Wrong !",
                                    style: TextStyle(color: Colors.cyan[800]),
                                  ),
                                  content: Text(
                                      "please try with another picture",
                                      style:
                                          TextStyle(color: Colors.cyan[800])),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                ));
                      }

                      // img.Image photo;
                      // photo = img.decodeImage(values);
                    }),
              ),
            ],
          )),
    );
  }
}

//  _sendImages(File image) async {

//    Dio dio = Dio();
// String url = "http://192.168.88.224:4000/upload";
//    FormData formData = FormData.fromMap({
//       "file":
//           await MultipartFile.fromFile(image.path, filename:basename(image.path)),
//   });
//   // formData.add("Image",Upload)
//   dio.post(url,data:formData,options: Options(
//     method: "POST",
//  //   responseType: ResponseType.json
// contentType:'multipart/form-data'//  MediaType("image", "jpeg"),//Headers.jsonContentType,
//   )).then((response){
//     print(response);
//   });

// //String imageName = image.path.split('/').last;
// http.MultipartRequest request =
//     http.MultipartRequest('POST', Uri.parse(url));
// request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

// request.files.add(
//   await http.MultipartFile.fromPath("Image", image.path,

//            // filename: imageName, contentType: MediaType('application', 'x-tar')
//             // 'image',
//             // // bytes,
//             // filename: 'somefile', // optional
//             // contentType:  MediaType('image', 'jpeg'),
//             ),
//       );

//       http.StreamedResponse r = await request.send();

//       print("object");
//       print(r.statusCode);
//       print(r.reasonPhrase.toString());

//    }
