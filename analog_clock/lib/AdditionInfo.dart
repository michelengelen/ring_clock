import 'package:analog_clock/ForecastIcon.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo({
    @required this.temperatureInfo,
    @required this.location,
    @required this.conditionString,
    @required this.condition,
    @required this.daytime,
  });

  final TemperatureInfo temperatureInfo;
  final String location;
  final String conditionString;
  final WeatherCondition condition;
  final Daytime daytime;

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontWeight: FontWeight.w900,
      color: Theme.of(context).primaryColor,
      fontSize: 24,
    );

    Widget _getTemperatureText(TemperatureType temperatureType) {
      final TextStyle _temperatureValueStyle = _textStyle.copyWith(
        fontSize: temperatureType == TemperatureType.current ? 60 : 24,
      );

      final TextStyle _temperatureUnitStyle = _temperatureValueStyle.copyWith(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.w300,
      );

      final List<Widget> _temperatureParts = <Widget>[];
      String _temperatureValue;
      switch (temperatureType) {
        case TemperatureType.current:
          _temperatureValue = temperatureInfo.temperature.toString();
          break;
        case TemperatureType.low:
          _temperatureParts.add(
            Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                FontAwesomeIcons.temperatureLow,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
            ),
          );
          _temperatureValue = temperatureInfo.temperatureMin.toString();
          break;
        case TemperatureType.high:
          _temperatureParts.add(
            Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                FontAwesomeIcons.temperatureHigh,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
            ),
          );
          _temperatureValue = temperatureInfo.temperatureMax.toString();
          break;
      }

      _temperatureParts.addAll(<Widget>[
        Text(
          _temperatureValue,
          style: _temperatureValueStyle,
        ),
        Text(
          temperatureInfo.temperatureUnit,
          style: _temperatureUnitStyle,
        ),
      ]);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _temperatureParts,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.only(left: 72.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
                child: Semantics.fromProperties(
                  properties: SemanticsProperties(
                    label: 'Forecast Icon showing that it is currently $conditionString',
                    value: conditionString,
                  ),
                  child: ForecastIcon(
                    size: width * 0.6,
                    weather: condition,
                    daytime: daytime,
                    baseColor: Theme.of(context).accentColor,
                    cloudColor: Theme.of(context).accentColor,
                    sunColor: Theme.of(context).primaryColor,
                    moonColor: Theme.of(context).primaryColorDark,
                    rainColor: Theme.of(context).splashColor,
                    snowColor: Theme.of(context).primaryColorLight,
                    thunderColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Divider(
                height: 4,
                thickness: 2,
                indent: width / 5,
                endIndent: width / 5,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Semantics.fromProperties(
                      properties: SemanticsProperties(
                        label:
                            'Current temperature ${temperatureInfo.temperature.toString()}${temperatureInfo.temperatureUnit}',
                        value: '${temperatureInfo.temperature.toString()}${temperatureInfo.temperatureUnit}',
                      ),
                      child: _getTemperatureText(TemperatureType.current),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                          child: Semantics.fromProperties(
                            properties: SemanticsProperties(
                              label:
                                  'lowest temperature to be expected today is: ${temperatureInfo.temperatureMin.toString()}${temperatureInfo.temperatureUnit}',
                              value: '${temperatureInfo.temperatureMin.toString()}${temperatureInfo.temperatureUnit}',
                            ),
                            child: _getTemperatureText(TemperatureType.low),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                          child: Semantics.fromProperties(
                            properties: SemanticsProperties(
                              label:
                                  'highest temperature to be expected today is: ${temperatureInfo.temperatureMax.toString()}${temperatureInfo.temperatureUnit}',
                              value: '${temperatureInfo.temperatureMax.toString()}${temperatureInfo.temperatureUnit}',
                            ),
                            child: _getTemperatureText(TemperatureType.high),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                thickness: 2,
                indent: width / 5,
                endIndent: width / 5,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Semantics.fromProperties(
                  properties: SemanticsProperties(
                    label: 'Your current location is $location',
                    value: location,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Theme.of(context).accentColor,
                          size: 40,
                        ),
                      ),
                      Text(
                        location,
                        style: _textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum TemperatureType {
  high,
  low,
  current,
}
