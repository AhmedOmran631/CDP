import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/OptionsScreen');
            },
            child: Center(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.white),
              child: Image.asset(
                "assets/CDP.jpg",
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            )),
          ),
          Center(
              child: Text(
            'D C P',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ))
        ],
      ),
    );
  }
}
