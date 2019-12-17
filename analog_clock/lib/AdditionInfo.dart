import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

String getWeatherIcon(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.cloudy:
      return '\u{f002}';
      break;
    case WeatherCondition.foggy:
      return '\u{f003}';
      break;
    case WeatherCondition.rainy:
      return '\u{f008}';
      break;
    case WeatherCondition.snowy:
      return '\u{f00a}';
      break;
    case WeatherCondition.thunderstorm:
      return '\u{f010}';
      break;
    case WeatherCondition.sunny:
    default:
      return '\u{f00d}';
  }
}

TextStyle _iconStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'WeatherIcons',
);
TextStyle _textStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 20,
);

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo({
    @required this.temperature,
    @required this.temperatureRange,
    @required this.location,
    @required this.conditionString,
    @required this.condition,
  });

  final String temperature;
  final String temperatureRange;
  final String location;
  final String conditionString;
  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                getWeatherIcon(condition),
                style: _iconStyle,
              ),
              Text(
                conditionString,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '\u{f055}',
                style: _iconStyle,
              ),
              Text(
                temperatureRange,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '\u{f03c}',
                style: _iconStyle,
              ),
              Text(
                temperature,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '\u{f0b1}',
                style: _iconStyle,
              ),
              Text(
                location,
                style: _textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
