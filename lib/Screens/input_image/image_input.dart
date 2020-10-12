
import 'dart:io';

import 'package:drawing/Screens/imagePreview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function setImage;
  final File image;

  ImageInput(this.setImage, this.image);
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  _getImage(BuildContext context, ImageSource source) async {
// ignore: deprecated_member_use
    await ImagePicker.pickImage(
      source: source,
    ).then((File image) {
      setState(() {
        _imageFile = image;
        print(path.basename(image.path));
      });
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(color: Colors.grey[100]),
            height: 170.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'pick up the image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('open the camera'),
                onPressed: () async {
                  await _getImage(context, ImageSource.camera).then((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagePreview(_imageFile)));
                  });
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('import from the library'),
                onPressed: () async {
                  await _getImage(context, ImageSource.gallery).then((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagePreview(_imageFile)));
                  });
                },
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget _option3() {
      return GestureDetector(
          onTap: () {
            _openImagePicker(context);
          },
          child: Stack(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 65, top: 10),
                  width: 200,
                  height: 65,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.deepOrangeAccent, width: 3),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      "import photo ",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
              Container(
                width: 90,
                height: 85,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepOrangeAccent, width: 3),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Icon(Icons.photo,size: 36,),
              ),
            ],
          ));
    }
   
    return _option3();
  }
}

