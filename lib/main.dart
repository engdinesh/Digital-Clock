import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digital_clock/model.dart';

import 'digital_clock.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(// navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(new MaterialApp(
      // Title
      title: "Digital Clock",
      // Home
      home: new DigitalClock(new ClockModel())));
}