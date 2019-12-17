// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/AdditionInfo.dart';
import 'package:analog_clock/DrawnHoursRing.dart';
import 'package:analog_clock/DrawnMinutesRing.dart';
import 'package:analog_clock/DrawnSecondsRing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final double radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final double radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _now = DateTime.now();
  String _temperature = '';
  String _temperatureRange = '';
  WeatherCondition _condition = WeatherCondition.sunny;
  String _conditionString = '';
  String _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
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
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherCondition;
      _conditionString = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Colors.lime,
            highlightColor: Colors.blueGrey,
            accentColor: Colors.blueGrey,
            backgroundColor: Colors.grey[900],
          )
        : Theme.of(context).copyWith(
            // Seconds Ring and Separator
            // #E63F3E
            primaryColor: Colors.deepOrange,
            // active Ring
            highlightColor: Colors.grey,
            // inactive Ring.
            accentColor: Colors.grey,
            backgroundColor: Colors.grey[200],
          );

    final String time = DateFormat.Hms().format(DateTime.now());
    final int currentHour = _now.hour >= 12 ? _now.hour - 12 : _now.hour;

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double squareLength =
              constraints.maxWidth > constraints.maxHeight ? constraints.maxHeight : constraints.maxWidth;

          final double baseWidth = squareLength / 6;
          final double minuteThickness = 6.0;
          const double secondThickness = 8.0;

          return Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                    color: customTheme.backgroundColor,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Stack(
                              children: <Widget>[
                                DrawnHoursRing(
                                  color: Colors.white10,
                                  fillColor: Colors.white,
                                  thickness: minuteThickness,
                                  inset: 0,
                                  angleRadians: currentHour * radiansPerHour,
                                ),
                                Center(
                                  child: Text(
                                    _now.hour < 10 ? '0${_now.hour}' : '${_now.hour}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 120,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'RobotoMono'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Stack(
                              children: <Widget>[
                                DrawnMinutesRing(
                                  color: Colors.white10,
                                  fillColor: Colors.white,
                                  thickness: minuteThickness,
                                  inset: 0,
                                  angleRadians: _now.minute * radiansPerTick,
                                ),
                                Center(
                                  child: Text(
                                    _now.minute < 10 ? '0${_now.minute}' : '${_now.minute}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 120,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'RobotoMono'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Stack(
                              children: <Widget>[
                                DrawnSecondRing(
                                  color: Colors.white10,
                                  fillColor: Colors.white,
                                  thickness: minuteThickness,
                                  inset: 0,
                                  angleRadians: _now.second * radiansPerTick,
                                ),
                                Center(
                                  child: Text(
                                    _now.second < 10 ? '0${_now.second}' : '${_now.second}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 120,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'RobotoMono'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
//                      InnerClock(
//                        size: baseWidth,
//                        hour: currentHour,
//                        minute: _now.minute,
//                      ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: AdditionalInfo(
                  temperature: _temperature,
                  temperatureRange: _temperatureRange,
                  condition: _condition,
                  conditionString: _conditionString,
                  location: _location,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
