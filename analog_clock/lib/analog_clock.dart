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
            highlightColor: Colors.grey[800],
            indicatorColor: Colors.grey[400],
            accentColor: Colors.lime[600],
            backgroundColor: Colors.white,
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.amberAccent,
            highlightColor: Colors.grey[200],
            indicatorColor: Colors.grey[800],
            accentColor: Colors.amberAccent[700],
            backgroundColor: Colors.grey[900],
          );

    final String time = DateFormat.Hms().format(DateTime.now());
    final int currentHour = _now.hour >= 12 ? _now.hour - 12 : _now.hour;

    final TextStyle clockTextStyle = TextStyle(
      color: customTheme.highlightColor,
      fontSize: 90,
      fontWeight: FontWeight.w300,
      fontFamily: 'RobotoMono'
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double minuteThickness = 12.0;

          return Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(96),
                  child: Stack(
                    children: <Widget>[
                      DrawnHoursRing(
                        color: Colors.black12,
                        fillColor: customTheme.accentColor,
                        thickness: minuteThickness,
                        inset: minuteThickness * -4.0,
                        angleRadians: currentHour * radiansPerHour,
                      ),
                      DrawnMinutesRing(
                        color: Colors.black12,
                        fillColor: customTheme.accentColor,
                        thickness: minuteThickness,
                        inset: 0,
                        angleRadians: _now.minute * radiansPerTick,
                      ),
                      DrawnSecondRing(
                        color: Colors.black12,
                        fillColor: customTheme.accentColor,
                        thickness: minuteThickness,
                        inset: minuteThickness * 4.0,
                        angleRadians: _now.second * radiansPerTick,
                      ),
//                      Center(
//                        child: InnerClock(
//                          size: constraints.maxWidth / 7.0,
//                          hour: currentHour,
//                          minute: _now.minute,
//                        ),
//                      ),
                      Center(
                        child: Text(
                          '${_now.hour}:${_now.minute}',
                          style: clockTextStyle
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: customTheme.highlightColor,
                  child: AdditionalInfo(
                    iconColor: customTheme.backgroundColor,
                    textColor: customTheme.primaryColor,
                    temperature: _temperature,
                    temperatureRange: _temperatureRange,
                    condition: _condition,
                    conditionString: _conditionString,
                    location: _location,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
