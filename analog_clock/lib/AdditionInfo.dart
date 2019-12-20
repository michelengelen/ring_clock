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
    @required this.temperatureMin,
    @required this.temperatureMax,
    @required this.location,
    @required this.conditionString,
    @required this.condition,
  });

  final Color iconColor;
  final Color textColor;
  final String temperature;
  final String temperatureMin;
  final String temperatureMax;
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
      fontFamily: 'FiraSans',
      fontWeight: FontWeight.w300,
      color: textColor,
      fontSize: 20,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    getWeatherIcon(condition),
                    style: _iconStyle,
                  )),
              Text(
                conditionString,
                style: _textStyle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  temperature,
                  style: _textStyle.copyWith(fontSize: 50),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.longArrowAltUp,
                        color: textColor,
                        size: 12,
                      ),
                      Text(
                        temperatureMax,
                        style: _textStyle,
                      ),
                    ],
                  ),
                  Divider(
                    height: 5.0,
                    thickness: 15.0,
                    indent: 0.0,
                    endIndent: 0.0,
                    color: textColor,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.longArrowAltDown,
                        color: textColor,
                        size: 12,
                      ),
                      Text(
                        temperatureMin,
                        style: _textStyle,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2),
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
