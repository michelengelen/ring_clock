import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

IconData getWeatherIcon2(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.cloudy:
      return FontAwesomeIcons.cloud;
      break;
    case WeatherCondition.foggy:
      return FontAwesomeIcons.smog;
      break;
    case WeatherCondition.rainy:
      return FontAwesomeIcons.cloudRain;
      break;
    case WeatherCondition.snowy:
      return FontAwesomeIcons.snowflake;
      break;
    case WeatherCondition.thunderstorm:
      return FontAwesomeIcons.bolt;
      break;
    case WeatherCondition.sunny:
    default:
      return FontAwesomeIcons.sun;
  }
}

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo({
    @required this.iconColor,
    @required this.textColor,
    @required this.temperature,
    @required this.temperatureRange,
    @required this.location,
    @required this.conditionString,
    @required this.condition,
  });

  final Color iconColor;
  final Color textColor;
  final String temperature;
  final String temperatureRange;
  final String location;
  final String conditionString;
  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {

    final TextStyle _iconStyle = TextStyle(
      fontFamily: 'WeatherIcons',
      color: iconColor,
      fontSize: 30,
    );
    final TextStyle _textStyle = TextStyle(
      fontFamily: 'RobotoMono',
      color: textColor,
      fontSize: 20,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  getWeatherIcon(condition),
                  style: _iconStyle,
                )
              ),
              Text(
                conditionString,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  FontAwesomeIcons.thermometerThreeQuarters,
                  color: iconColor,
                  size: 40,
                ),
              ),
              Text(
                temperature,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  FontAwesomeIcons.mapMarkerAlt,
                  color: iconColor,
                  size: 40,
                ),
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
