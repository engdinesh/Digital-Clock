// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart';
import 'container_hand.dart';
import 'drawn_hand.dart';
import 'model.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
///
enum _Element {
  background,
  text,
  shadow,
}


/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {


      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      /*_timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );*/
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
         _timer = Timer(
         Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
          _updateTime,
       );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
      // Hour hand.
      primaryColor: Color(0xff3fa57c),
      // Minute hand.
      highlightColor: Color(0xff65b796),
      // Second hand.
      accentColor: Color(0xff4FCF9B),
      backgroundColor: Color(0xFFD2E3FC),
    )
        : Theme.of(context).copyWith(
      primaryColor: Color(0xFFD2E3FC),
      highlightColor: Color(0xFF4285F4),
      accentColor: Color(0xFF8AB4F8),
      backgroundColor: Color(0xFF3C4043),
    );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xff38946f),Color(0xff3fa57c)],
    ).createShader(Rect.fromLTWH(50.0, 0.0, 200.0, 70.0));
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'hh' : 'HH').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final day = DateFormat('E d').format(_dateTime);
    final second = DateFormat('s a').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;

    return Stack(children: <Widget>[
        new Container(
          color: Color(0xff052F43),

        ),

        Center(
          child:new Container(
            height: (MediaQuery.of(context).size.height - 100),
            width: (MediaQuery.of(context).size.width - 100),
            child: ShaderMask(
              child: Image.asset("assets/clock_circle.png"),
              shaderCallback: (Rect bounds)
              {
                return  LinearGradient(
                  colors: <Color>[Color(0xff38946f),Color(0xff3fa57c)],
                  stops: [0.5,0.3],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
            ),
          ),
        ),
        new Container(
            alignment: Alignment.center,
            margin:EdgeInsets.fromLTRB(20, 50, 0, 0),
            child:new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Text(hour,style: new TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Digital_Dismay',
                          letterSpacing: 6,
                          foreground: Paint()..shader = linearGradient),),
                     Text(":",style: new TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Digital_Dismay',
                          letterSpacing: 6,
                          foreground: Paint()..shader = linearGradient),),
                      Text(minute,style: new TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Digital_Dismay',
                          letterSpacing: 6,
                          foreground: Paint()..shader = linearGradient),),
                    new Container(
                      width: 34,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(3.0),
                      child: Text(second.toUpperCase(),style: new TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1,
                          decoration: TextDecoration.none,
                          color: Color(0xff3fa57c)),
                    ),
                    )
                  ],
                )
            ),
              new Container(
                margin:EdgeInsets.fromLTRB(150, 0, 0, 0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                    border: Border.all(color: Color(0xff38946f),width: 2)
                ),
                child: Text(day.toUpperCase(),style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color(0xff38946f),
                   ),),
              ),
               new Container(
                  margin:EdgeInsets.fromLTRB(0, 0, 70, 0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage("assets/clock_circle.png"),
                       fit: BoxFit.cover,
                     ),
                     borderRadius: new BorderRadius.all(new Radius.circular(100.0)),

                 ),
                  child: Stack(
                    children: [
                      // Example of a hand drawn with [CustomPainter].
                      DrawnHand(
                        color: customTheme.accentColor,
                        thickness: 2,
                        size: 0.8,
                        angleRadians: _dateTime.second * radiansPerTick,
                      ),
                      DrawnHand(
                        color: customTheme.highlightColor,
                        thickness: 3,
                        size: 0.6,
                        angleRadians: _dateTime.minute * radiansPerTick,
                      ),
                      // Example of a hand drawn with [Container].
                      ContainerHand(
                        color: Color.fromRGBO(255, 255, 255, 0.0),
                        size: 0.4,
                        angleRadians: _dateTime.hour * radiansPerHour +
                            (_dateTime.minute / 60) * radiansPerHour,
                        child: Transform.translate(
                          offset: Offset(0.0, -26.0),
                          child: Container(
                            width: 10,
                            height: 50,
                            decoration: BoxDecoration(
                              color: customTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
          ],)
        ),




    ],);
  }
}
