import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

/// [ForecastIcon] is a very basic forecast icon class with the possibility to change the color of each part.
///
/// Since this is still pretty much a work in progress it is still a bit prone to improvements,
/// but since I ran out of time this should do it.
///
/// I am using the awesome [Forecast Font](https://webdesignbestfirm.com/forecastfont.html)
@immutable
class ForecastIcon extends StatelessWidget {
  const ForecastIcon({
    @required this.size,
    @required this.weather,
    @required this.baseColor,
    this.daytime = Daytime.day,
    this.sunColor,
    this.moonColor,
    this.cloudColor,
    this.rainColor,
    this.snowColor,
    this.thunderColor,
  })  : assert(size != null),
        assert(weather != null),
        assert(baseColor != null);

  /// the icons size
  final double size;

  /// the [WeatherCondition] to determine the icon
  final WeatherCondition weather;

  /// the [Daytime] (day or night)
  final Daytime daytime;

  /// color which is used as a fallback
  final Color baseColor;

  /// color for the sun
  final Color sunColor;

  /// color for the moon
  final Color moonColor;

  /// color for the clouds
  final Color cloudColor;

  /// color for the rain
  final Color rainColor;

  /// color for the snow
  final Color snowColor;

  /// color for the thunder
  final Color thunderColor;

  /// a little helper-function to get the correct icon-set
  List<Widget> _getForecastIcons() {
    /// the base [TextStyle] which gets copied with the correct
    /// color for each part of the complete icon
    final TextStyle _baseStyle = TextStyle(
      fontFamily: 'Forecast',
      fontSize: size,
      color: baseColor,
      fontWeight: FontWeight.w400,
    );

    /// style to use for the clouds
    final TextStyle _cloudStyle = _baseStyle.copyWith(
      color: cloudColor ?? baseColor,
    );

    /// style to use for the sun
    final TextStyle _sunStyle = _baseStyle.copyWith(
      color: sunColor ?? cloudColor ?? baseColor,
    );

    /// style to use for the moon
    final TextStyle _moonStyle = _baseStyle.copyWith(
      color: moonColor ?? sunColor ?? cloudColor ?? baseColor,
    );

    /// style to use for the thunder
    final TextStyle _thunderStyle = _baseStyle.copyWith(
      color: thunderColor ?? sunColor ?? cloudColor ?? baseColor,
    );

    /// style to use for the rain
    final TextStyle _rainStyle = _baseStyle.copyWith(
      color: rainColor ?? cloudColor ?? baseColor,
    );

    /// style to use for the snow
    final TextStyle _snowStyle = _baseStyle.copyWith(
      color: snowColor ?? rainColor ?? cloudColor ?? baseColor,
    );

    /// add the basecloud to the set first. When it is not needed (sunny, foggy or cloudy) it will be overwritten
    List<Widget> forecastIcons = <Widget>[
      Text('\u{f105}', style: _cloudStyle),
    ];

    switch (weather) {
      case WeatherCondition.sunny:

        /// determine to show either a sun or a moon
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

    /// Check if the icons that are used can take a moon or sun as an addition.
    /// Sadly the font does not provide this addition for the cloudy icon,
    /// so we have to exclude this as well
    if (weather != WeatherCondition.sunny && weather != WeatherCondition.foggy && weather != WeatherCondition.cloudy) {
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

/// a small enum to determine if it is day or night
enum Daytime { day, night }
