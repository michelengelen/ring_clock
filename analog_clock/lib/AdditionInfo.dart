import 'package:analog_clock/ForecastIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    @required this.daytime,
  });

  final Color iconColor;
  final Color textColor;
  final String temperature;
  final String temperatureMin;
  final String temperatureMax;
  final String location;
  final String conditionString;
  final WeatherCondition condition;
  final Daytime daytime;

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle = TextStyle(
      fontFamily: 'SourceSansPro',
      fontWeight: FontWeight.w900,
      color: textColor,
      fontSize: 20,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
//        final double width = constraints.maxWidth;

        return Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ForecastIcon(
                          size: 260.0,
                          weather: condition,
                          daytime: daytime,
                          cloudColor: Colors.grey[700],
                          sunColor: Colors.yellow,
                          moonColor: Colors.blue[100],
                          rainColor: Colors.blue,
                          snowColor: Colors.white,
                          thunderColor: Colors.yellow[700],
                        ),
                      ),
//                      Text(
//                        conditionString,
//                        style: _textStyle,
//                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
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
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          temperature,
                          style: _textStyle.copyWith(fontSize: 70),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      FontAwesomeIcons.temperatureHigh,
                                      color: iconColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    temperatureMax,
                                    style: _textStyle.copyWith(color: textColor.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      FontAwesomeIcons.temperatureLow,
                                      color: iconColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    temperatureMin,
                                    style: _textStyle.copyWith(color: textColor.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
