import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/searchScreen.dart';
import 'package:weather_icons/weather_icons.dart';
import 'homeLocationScreen.dart';
import 'package:date_time_format/date_time_format.dart';

class CustomCityWeather extends StatefulWidget {
  CustomCityWeather({this.city});
  final city;
  @override
  _CustomCityWeatherState createState() => _CustomCityWeatherState();
}

var cityName;
var currentTemp;
var chanceRain;
var cTemp;
var dayOfWeek;
var dateOne;
var date;
var dTwo;
var dateTwo;
var dayTwoOfWeek;
var maxDayOne;
var minDayOne;
var maxDayOneInit;
var minDayOneInit;
var dayOneCondition;
var dayOneChanceRain;
var maxDayTwo;
var minDayTwo;
var maxDayTwoInit;
var minDayTwoInit;
var dayTwoCondition;
var dayTwoChanceRain;
var currentMaxInit;
var currentMinInit;
var currentMax;
var currentMin;
var currentCondition;

class _CustomCityWeatherState extends State<CustomCityWeather> {
  @override
  void initState() {
    super.initState();
    updateSearchCity(widget.city);
  }

  updateSearchCity(dynamic gotForecast) {
    setState(() {
      cityName = gotForecast['location']['name'];
      cTemp = gotForecast['current']['temp_f'];
      currentTemp = cTemp.toInt();
      chanceRain = gotForecast['forecast']['forecastday'][0]['day']
          ['daily_chance_of_rain'];
      currentMaxInit =
          gotForecast['forecast']['forecastday'][0]['day']['maxtemp_f'];
      currentMinInit =
          gotForecast['forecast']['forecastday'][0]['day']['mintemp_f'];
      currentMax = currentMaxInit.toInt();
      currentMin = currentMinInit.toInt();
      currentCondition =
          gotForecast['forecast']['forecastday'][0]['day']['condition']['text'];
      date = gotForecast['forecast']['forecastday'][1]['date'];
      dateOne = DateTime.parse(date);
      dayOfWeek = DateTimeFormat.format(dateOne, format: 'l');
      maxDayOneInit =
          gotForecast['forecast']['forecastday'][1]['day']['maxtemp_f'];
      minDayOneInit =
          gotForecast['forecast']['forecastday'][1]['day']['mintemp_f'];
      maxDayOne = maxDayOneInit.toInt();
      minDayOne = minDayOneInit.toInt();
      dayOneCondition =
          gotForecast['forecast']['forecastday'][1]['day']['condition']['text'];
      dayOneChanceRain = gotForecast['forecast']['forecastday'][1]['day']
          ['daily_chance_of_rain'];
      dTwo = gotForecast['forecast']['forecastday'][2]['date'];
      dateTwo = DateTime.parse(dTwo);
      dayTwoOfWeek = DateTimeFormat.format(dateTwo, format: 'l');
      maxDayTwoInit =
          gotForecast['forecast']['forecastday'][2]['day']['maxtemp_f'];
      minDayTwoInit =
          gotForecast['forecast']['forecastday'][2]['day']['mintemp_f'];
      maxDayTwo = maxDayOneInit.toInt();
      minDayTwo = minDayOneInit.toInt();
      dayTwoCondition =
          gotForecast['forecast']['forecastday'][2]['day']['condition']['text'];
      dayTwoChanceRain = gotForecast['forecast']['forecastday'][2]['day']
          ['daily_chance_of_rain'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Images/waterfall.gif'), fit: BoxFit.cover),
          ),
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: OutlineButton(
                          borderSide: BorderSide(
                            width: 3,
                            color: Colors.white,
                          ),
                          child: Text(
                            'New Location',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: OutlineButton(
                            disabledBorderColor: Colors.white,
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 3,
                            ),
                            child: Text(
                              'Current Location',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              var counter = 0;
                              Navigator.popUntil(
                                context,
                                (route) {
                                  return counter++ == 2;
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        '$cityName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                  //Date
                  Text(
                    '$formatTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text(
                      '$currentTemp°',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$currentMax°/$currentMin°',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '$currentCondition',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoxedIcon(
                        WeatherIcons.rain,
                        color: Colors.white,
                        size: 25,
                      ),
                      Text(
                        '$chanceRain%',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          width: 150,
                          height: 90,
                          child: Card(
                            color: Colors.white70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '$dayOfWeek',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('$maxDayOne°/$minDayOne°'),
                                    Text('$dayOneCondition'),
                                    Row(
                                      children: [
                                        BoxedIcon(
                                          WeatherIcons.rain,
                                          size: 15,
                                        ),
                                        Text('$dayOneChanceRain%'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          height: 90,
                          child: Card(
                            color: Colors.white70,
                            child: Column(
                              children: [
                                Text(
                                  '$dayTwoOfWeek',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('$maxDayTwo°/$minDayTwo°'),
                                Text('$dayTwoCondition'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BoxedIcon(
                                      WeatherIcons.rain,
                                      size: 15,
                                    ),
                                    Text('$dayTwoChanceRain%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
