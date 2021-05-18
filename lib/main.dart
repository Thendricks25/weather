import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather/homeLocationScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/searchScreen.dart';
import 'location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(),
      //}
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
    currentLocation();
  }

  currentLocation() async {
    await location.getLocation();
    GetWeatherData getWeatherData = GetWeatherData();
    var gotName = await getWeatherData.getCityName();
    var gotWeather = await getWeatherData.getWeather();
    var gotAlert = await getWeatherData.getWeatherAlerts();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            locationName: gotName,
            locationWeather: gotWeather,
            locationAlert: gotAlert,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/sun.gif'),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 290.0),
              child: Text(
                'Please wait while we find your location...',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
