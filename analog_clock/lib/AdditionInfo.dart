import 'package:analog_clock/ForecastIcon.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// class that renders the additional info to the right of the clock
///
/// It takes in a [WeatherCondition] and [Daytime] to determine the
/// correct [ForecastIcon], as well as a [TemperatureInfo] helper class
/// for rendering the temperatures and location information
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

    /// helper function to get the correct temperature strings with the correct styling
    Widget _getTemperatureText(TemperatureType temperatureType) {
      /// basic temperature styles
      final TextStyle _temperatureValueStyle = _textStyle.copyWith(
        fontSize: temperatureType == TemperatureType.current ? 72 : 24,
      );

      /// styles for the temperature unit
      final TextStyle _temperatureUnitStyle = _temperatureValueStyle.copyWith(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.w400,
      );

      /// a List to gather all parts for the temperature
      final List<Widget> _temperatureParts = <Widget>[];

      /// the temperature value
      String _temperatureValue;

      switch (temperatureType) {
        case TemperatureType.current:
          _temperatureValue = temperatureInfo.temperature.toString();
          break;
        case TemperatureType.low:
        case TemperatureType.high:
          /// if the type is not current define an icon to be added before the temperature value
          _temperatureParts.add(
            Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                temperatureType == TemperatureType.low
                  ? FontAwesomeIcons.longArrowAltDown
                  : FontAwesomeIcons.longArrowAltUp,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
            ),
          );

          /// get the correct value
          _temperatureValue = temperatureType == TemperatureType.low
            ? temperatureInfo.temperatureMin.toString()
            : temperatureInfo.temperatureMax.toString();
          break;
      }

      /// combine all parts
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

/// helper enum to better determine which
/// temperature we are looking to render
enum TemperatureType {
  high,
  low,
  current,
}
