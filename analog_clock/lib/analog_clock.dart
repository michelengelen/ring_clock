// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/AdditionInfo.dart';
import 'package:analog_clock/DrawnClockBase.dart';
import 'package:analog_clock/DrawnHoursRing.dart';
import 'package:analog_clock/DrawnMinutesRing.dart';
import 'package:analog_clock/ForecastIcon.dart';
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
  TemperatureInfo _temperatureInfo =
      TemperatureInfo(temperature: 0.0, temperatureMin: 0.0, temperatureMax: 0.0, temperatureUnit: '');
  WeatherCondition _condition = WeatherCondition.sunny;
  String _conditionString = '';
  String _location = '';
  Timer _timer;
  Daytime _daytime = Daytime.day;

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
      _temperatureInfo = TemperatureInfo(
        temperature: widget.model.temperature,
        temperatureMax: widget.model.high,
        temperatureMin: widget.model.low,
        temperatureUnit: widget.model.unitString,
      );
      _condition = widget.model.weatherCondition;
      _conditionString = widget.model.weatherString;
      _location = widget.model.location;
      _daytime = _now.hour > 6 || _now.hour < 18 ? Daytime.day : Daytime.night;
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
        ? ThemeData(
            primarySwatch: Colors.lime,
            accentColor: Colors.brown[700],
            highlightColor: Colors.grey[800],
            indicatorColor: Colors.white30,
            backgroundColor: Colors.grey[200],
            splashColor: Colors.blueAccent,
          )
        : ThemeData(
            primarySwatch: Colors.lime,
            accentColor: Colors.grey[300],
            highlightColor: Colors.grey[400],
            indicatorColor: Colors.blueGrey[300],
            backgroundColor: Colors.blueGrey[900],
            splashColor: Colors.blueAccent,
          );

    final String time = DateFormat.Hms().format(DateTime.now());
    final int currentHour = _now.hour >= 12 ? _now.hour - 12 : _now.hour;

    return Theme(
      data: customTheme,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          /// width of the clock-face ring
          final double baseWidth = constraints.maxWidth / 12;

          /// by using 35% of the baseWidth we ensure that the arrow-points never reach each other
          final double arrowSize = baseWidth * 0.35;

          /// adding [ClipRect] widget here is used for setting a boundary to the [CustomPainter]
          /// according to the docs (https://api.flutter.dev/flutter/widgets/ClipRect-class.html)
          /// several widgets are commonly painting outside their boundaries and [ClipRect] can prevent
          /// that from happening.
          /// We still want to paint the right fancy material-style separation so we only use
          /// this on the outer container to prevent overflow
          return ClipRect(
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Semantics.fromProperties(
                    properties: SemanticsProperties(
                      label: 'Analog clock with time $time',
                      value: time,
                    ),
                    child: Container(
                      color: customTheme.backgroundColor,
                      child: Stack(
                        children: <Widget>[
                          DrawnClockBase(
                            baseWidth: baseWidth,
                          ),
                          DrawnHoursRing(
                            arrowSize: arrowSize,
                            angleRadians: currentHour * radiansPerHour + (_now.minute / 60) * radiansPerHour,
                          ),
                          DrawnMinutesRing(
                            inset: baseWidth,
                            arrowSize: arrowSize,
                            angleRadians: _now.minute * radiansPerTick,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    /// this should be transparent for letting the other part paint the stylish separation
                    color: Colors.transparent,
                    child: AdditionalInfo(
                      temperatureInfo: _temperatureInfo,
                      condition: _condition,
                      conditionString: _conditionString,
                      location: _location,
                      daytime: _daytime,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// helper class for passing the temperature to the [AdditionalInfo] class
class TemperatureInfo {
  TemperatureInfo({
    @required this.temperature,
    @required this.temperatureMin,
    @required this.temperatureMax,
    @required this.temperatureUnit,
  });

  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final String temperatureUnit;
}
