import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/CustomCityWeather.dart';

import 'homeLocationScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

var customName;

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    String customName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Location'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/city.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35),
                child: TextField(
                  onChanged: (value) {
                    customName = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    hintText: 'City Name, State or Zip Code',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: OutlineButton(
                  child: Text(
                    'Get Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  disabledBorderColor: Colors.white,
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                  onPressed: () async {
                    GetWeatherData getWeatherData = GetWeatherData();
                    var gotForecast =
                        await getWeatherData.getForecast(customName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomCityWeather(
                                  city: gotForecast,
                                )));
                    TextEditingController searchBar = TextEditingController();
                    searchBar.clear();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
