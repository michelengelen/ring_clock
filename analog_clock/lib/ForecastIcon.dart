import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

@immutable
class ForecastIcon extends StatelessWidget {
  const ForecastIcon({
    @required this.size,
    @required this.weather,
    this.daytime = Daytime.day,
    this.sunColor,
    this.moonColor,
    this.cloudColor,
    this.rainColor,
    this.snowColor,
    this.thunderColor,
  });

  final double size;
  final WeatherCondition weather;
  final Daytime daytime;
  final Color sunColor;
  final Color moonColor;
  final Color cloudColor;
  final Color rainColor;
  final Color snowColor;
  final Color thunderColor;

  List<Widget> _getForecastIcons() {
    final TextStyle _baseStyle =
        TextStyle(fontFamily: 'Forecast', fontSize: size, color: cloudColor, fontWeight: FontWeight.w400);
    final TextStyle _cloudStyle = _baseStyle.copyWith(color: cloudColor);
    final TextStyle _sunStyle = _baseStyle.copyWith(color: sunColor ?? cloudColor);
    final TextStyle _moonStyle = _baseStyle.copyWith(color: moonColor ?? sunColor ?? cloudColor);
    final TextStyle _thunderStyle = _baseStyle.copyWith(color: thunderColor ?? sunColor ?? cloudColor);
    final TextStyle _rainStyle = _baseStyle.copyWith(color: rainColor ?? cloudColor);
    final TextStyle _snowStyle = _baseStyle.copyWith(color: snowColor ?? rainColor ?? cloudColor);

    List<Widget> forecastIcons = <Widget>[
      Text('\u{f105}', style: _cloudStyle),
    ];
    switch (weather) {
      case WeatherCondition.sunny:
        final String charCode = daytime == Daytime.day ? '\u{f113}' : '\u{f10d}';
        final TextStyle style = daytime == Daytime.day ? _sunStyle : _moonStyle;
        forecastIcons = <Widget>[
          Text(charCode, style: style),
        ];
        break;
      case WeatherCondition.cloudy:
        forecastIcons = <Widget>[
          Text('\u{f106}', style: _cloudStyle),
        ];
        break;
      case WeatherCondition.foggy:
        forecastIcons = <Widget>[
          Text('\u{f108}', style: _cloudStyle),
        ];
        break;
      case WeatherCondition.rainy:
        forecastIcons.add(
          Text('\u{f104}', style: _rainStyle),
        );
        break;
      case WeatherCondition.snowy:
        forecastIcons.add(
          Text('\u{f10b}', style: _snowStyle),
        );
        break;
      case WeatherCondition.thunderstorm:
        forecastIcons.add(
          Text('\u{f114}', style: _thunderStyle),
        );
        break;
      case WeatherCondition.windy:
        forecastIcons.add(
          Text('\u{f115}', style: _thunderStyle),
        );
        break;
    }

    if (daytime != null &&
        weather != WeatherCondition.sunny &&
        weather != WeatherCondition.foggy &&
        weather != WeatherCondition.cloudy) {
      final String daytimeChar = daytime == Daytime.day ? '\u{f101}' : '\u{f100}';
      final TextStyle daytimeStyle = daytime == Daytime.day ? _sunStyle : _moonStyle;
      forecastIcons.add(
        Text(daytimeChar, style: daytimeStyle),
      );
    }

    return forecastIcons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: Stack(
          children: _getForecastIcons(),
        ),
      ),
    );
  }
}

enum Daytime { day, night }
