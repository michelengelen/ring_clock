// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/AdditionInfo.dart';
import 'package:analog_clock/DrawnClockBase.dart';
import 'package:analog_clock/DrawnHoursRing.dart';
import 'package:analog_clock/DrawnMinutesRing.dart';
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
  String _temperatureMin = '';
  String _temperatureMax = '';
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
      _temperatureMax = widget.model.highString;
      _temperatureMin = widget.model.lowString;
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
            primaryColor: Colors.amber,
            highlightColor: Colors.grey[800],
            indicatorColor: Colors.white30,
            accentColor: Colors.amber[700],
            backgroundColor: Colors.grey[100],
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.red,
            highlightColor: Colors.grey[200],
            indicatorColor: Colors.black26,
            accentColor: Colors.red[800],
            backgroundColor: Colors.grey[900],
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
          const double arrowSize = 20.0;
          const double baseWidth = 60.0;

          return Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  color: customTheme.backgroundColor,
                  child: Stack(
                    children: <Widget>[
                      DrawnClockBase(
                        accentColor: customTheme.accentColor,
                        primaryColor: customTheme.primaryColor,
                        tickColor: customTheme.indicatorColor,
                        baseWidth: baseWidth,
                      ),
                      DrawnHoursRing(
                        arrowSize: arrowSize,
                        angleRadians: currentHour * radiansPerHour,
                        backgroundColor: customTheme.backgroundColor,
                      ),
                      DrawnMinutesRing(
                        inset: baseWidth,
                        arrowSize: arrowSize,
                        angleRadians: _now.minute * radiansPerTick,
                        backgroundColor: customTheme.backgroundColor,
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
                    temperatureMax: _temperatureMax,
                    temperatureMin: _temperatureMin,
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
