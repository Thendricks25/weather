import 'dart:convert';
import 'dart:core';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:http/http.dart';
import 'package:weather/CustomCityWeather.dart';
import 'package:weather/forget.dart';
import 'package:weather/searchScreen.dart';
import 'package:weather_icons/weather_icons.dart';
import 'main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'location.dart';

//Gets the current date and displays it in Day of week, month,day, year format
var time = DateTime.now();
var formatTime =
    DateTimeFormat.format(time, format: AmericanDateFormats.dayOfWeekWithComma);

//First API to get current and forecast weather for lat and long location
class GetWeatherData {
  var cName;
  Future getWeather() async {
    Location location = Location();
    await location.getLocation();
    Response response = await get(
        'http://api.weatherapi.com/v1/forecast.json?key=$weatherapidotcom&q=${location.latitude},${location.longitude}&days=3');
    var jason = jsonDecode(response.body);
    return jason;
  }

// Second API to get city name of lat long location
  Future getCityName() async {
    Location location = Location();
    await location.getLocation();
    Response resp = await get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$openweathermap&units=imperial');
    var cJason = jsonDecode(resp.body);
    return cJason;
  }

//Third API to get weather alerts for lat long location
  Future getWeatherAlerts() async {
    Location location = Location();
    await location.getLocation();
    Response aResp = await get(
        'https://api.weatherbit.io/v2.0/alerts?lat=${location.latitude}&lon=${location.longitude}&key=$weatherbit');
    var alert = jsonDecode(aResp.body);
    return alert;
  }

//Fourth API to get weather data by city name or zip code entered on search page
  Future getForecast(customName) async {
    Response response = await get(
        'http://api.weatherapi.com/v1/forecast.json?key=$weatherapidotcom&q=$customName&days=5');
    var fjason = jsonDecode(response.body);
    return fjason;
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({this.locationName, this.locationWeather, this.locationAlert});
  final locationName;
  final locationWeather;
  final locationAlert;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    updateUiCity(widget.locationName);
    updateUiWeather(widget.locationWeather);
    updateUiWeatherAlert(widget.locationAlert);
  }

  var cName;
  var cTemperature;
  var cCondition;
  double temperature;
  var cWind;
  var wind;
  var fTemp;
  var feels;
  String aTitle;
  String aDescription;
  var title;
  var maxTemp;
  var minTemp;
  var maT;
  var miT;
  var check;
  var maTwo;
  var maxTwoTemp;
  var miTwo;
  var minTwoTemp;
  var dTwoCondition;
  var cRain;
  var dTwoRain;
  var miThree;
  var maThree;
  var minThreeTemp;
  var maxThreeTemp;
  var dThreeCondition;
  var dThreeRain;
  var date3;
  var dateThree;
  var dOfWeek;

  updateUiCity(dynamic gotName) {
    try {
      setState(() {
        cName = gotName['name'];
      });
    } catch (e) {
      print(e);
      setState(() {
        cName = "N/A";
      });
    }
  }

  updateUiWeather(dynamic gotWeather) {
    try {
      setState(() {
        temperature = gotWeather['current']['temp_f'];
        cCondition = gotWeather['current']['condition']['text'];
        cTemperature = temperature.toInt();
        cWind = gotWeather['current']['wind_mph'];
        wind = cWind.toInt();
        fTemp = gotWeather['current']['feelslike_f'];
        feels = fTemp.toInt();
        maT = gotWeather['forecast']['forecastday'][0]['day']['maxtemp_f'];
        maxTemp = maT.toInt();
        miT = gotWeather['forecast']['forecastday'][0]['day']['mintemp_f'];
        minTemp = miT.toInt();
        maTwo = gotWeather['forecast']['forecastday'][1]['day']['maxtemp_f'];
        maxTwoTemp = maTwo.toInt();
        miTwo = gotWeather['forecast']['forecastday'][1]['day']['mintemp_f'];
        minTwoTemp = miTwo.toInt();
        dTwoCondition = gotWeather['forecast']['forecastday'][1]['day']
            ['condition']['text'];
        cRain = gotWeather['forecast']['forecastday'][0]['day']
            ['daily_chance_of_rain'];
        dTwoRain = gotWeather['forecast']['forecastday'][1]['day']
            ['daily_chance_of_rain'];
        date3 = gotWeather['forecast']['forecastday'][2]['date'];
        dateThree = DateTime.parse(date3);
        dOfWeek = DateTimeFormat.format(dateThree, format: 'l');
        maThree = gotWeather['forecast']['forecastday'][2]['day']['maxtemp_f'];
        maxThreeTemp = maThree.toInt();
        miThree = gotWeather['forecast']['forecastday'][2]['day']['mintemp_f'];
        minThreeTemp = miThree.toInt();
        dThreeCondition = gotWeather['forecast']['forecastday'][2]['day']
            ['condition']['text'];
        dThreeRain = gotWeather['forecast']['forecastday'][2]['day']
            ['daily_chance_of_rain'];
      });
    } catch (e) {
      print(e);
    }
  }

  updateUiWeatherAlert(dynamic gotAlert) {
    try {
      setState(() {
        aTitle = gotAlert['alerts'][0]['title'];
        aDescription = gotAlert['alerts'][0]['description'];
      });
    } catch (e) {
      print(e);
    }
    if (aTitle == null) {
      aTitle = "No weather alerts at this time.";
      aDescription = "Everything is good. Enjoy your day.";
    }
  }

  Location location = Location();
  GetWeatherData getWeatherData = GetWeatherData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () {
                forecast(context);
              },
              child: Text(
                'Forecast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ));
              },
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          backgroundColor: Colors.black12,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Images/waterfall.gif'),
              fit: BoxFit.cover,
            ),
          ),
          child: EasyRefresh(
            child: ListView(
              children: [
                SafeArea(
                  child: Column(children: [
                    //Navigation Bar
                    //Location Name
                    Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '$cName',
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
                    //Alert Container
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//If there are no alerts to display make container transparent
                          aTitle == "No weather alerts at this time."
                              ? Container(
                                  height: 200,
                                  width: 360,
                                )
                              : Container(
                                  height: 200,
                                  width: 360,
                                  child: Card(
                                    color: Colors.white70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Weather Alert',
                                          style: TextStyle(
                                            color: Colors.red.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 20.0, right: 20),
                                          child: Text(
                                            '$aTitle',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'Learn More',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade900,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          onPressed: () {
                                            Alert(
                                                    context: context,
                                                    title: "Weather Alert",
                                                    desc: '$aDescription')
                                                .show();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '$cTemperature°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 100,
                                ),
                              ),
                            ),
                            Text(
                              'Feels Like: $feels°',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '$maxTemp° / $minTemp°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$cCondition',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            Row(
                              children: [
                                BoxedIcon(
                                  WeatherIcons.strong_wind,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  '$wind' + ' mph',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
            onRefresh: () async {
              var gotName = await getWeatherData.getCityName();
              var gotWeather = await getWeatherData.getWeather();
              updateUiCity(gotName);
              updateUiWeather(gotWeather);
              print('refreshed');
            },
            header: MaterialHeader(),
          ),
        ));
  }

  var condition = "Shady";
  var bigTemp;
  var lilTemp = "50";
  var poP = "5";
  var sunUp = "5:00 AM";
  var sunDown = "9:00 PM";

  void forecast(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '$cCondition',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '$maxTemp°/$minTemp°',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            BoxedIcon(WeatherIcons.rain),
                            Text(
                              '$cRain%',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Tomorrow',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '$dTwoCondition',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$maxTwoTemp°/$minTwoTemp°',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            BoxedIcon(WeatherIcons.rain),
                            Text(
                              '$dTwoRain%',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$dOfWeek',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '$dThreeCondition',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '$maxThreeTemp°/$minThreeTemp°',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            BoxedIcon(WeatherIcons.rain),
                            Text(
                              '$dThreeRain%',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
