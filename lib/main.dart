
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pranayfatingdemo/splash_screen.dart';

void main() => runApp(MyApp());
// void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

     SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // <--- Add the builder
      home: SplashScreen(),
//      home: Walkthrough(),
    );
  }

}
