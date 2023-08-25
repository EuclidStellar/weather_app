import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/envdata.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'additionalinfoitem.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  //int tempCelcius = 0;
  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      String cityName = 'Lucknow';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherapikey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred / API limit exceeded';
      }
      // temp =(data['list'][0]['main']['temp']);
      dynamic tempData = data['list'][0]['main']['temp'];
      if (tempData is int) {
        temp = tempData.toDouble(); // Convert int to double
      } else if (tempData is double) {
        temp = tempData; // Keep as double
      } else {
        throw 'Unexpected temperature data type';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getWeatherData();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          // defining API Stuff !!

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final pressure = currentWeatherData['main']['pressure'];
          final windspeed = currentWeatherData['wind']['speed'];
          final humidity = currentWeatherData['main']['humidity'];
          final tempincelcius = currentTemp - 273.15;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // main card

                SizedBox(
                  width: double.infinity,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Column(
                              children: [
                                Text(
                                  '${tempincelcius.toStringAsFixed(2)}° C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  currentSky == 'Clouds'
                                      ? Icons.cloud
                                      : currentSky == 'Clear'
                                          ? Icons.wb_sunny
                                          : currentSky == 'Rain'
                                              ? Icons.beach_access
                                              : Icons.wb_twilight,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  '$currentSky , Lucknow',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),

                const SizedBox(
                  height: 20,
                ),
                // forecast card
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 7; i++)
                        HourlyForecast(
                          time: data['list'][i]['dt_txt']
                              .toString()
                              .substring(11, 16),
                          icon: data['list'][i]['weather'][0]['main'] ==
                                  'Clouds'
                              ? Icons.cloud
                              : data['list'][i]['weather'][0]['main'] == 'Clear'
                                  ? Icons.wb_sunny
                                  : data['list'][i]['weather'][0]['main'] ==
                                          'Rain'
                                      ? Icons.beach_access
                                      : Icons.wb_twilight,
                          temp: (data['list'][i]['main']['temp'] - 273.15)
                              .toStringAsFixed(2),
                        ),
                    ],
                  ),
                ),
                // Additional Information Card
                const SizedBox(
                  height: 16,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalnfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalnfoItem(
                      icon: Icons.air_rounded,
                      label: 'Windspeed',
                      value: windspeed.toString(),
                    ),
                    AdditionalnfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Trouble while calling API so restructered the code

/*




import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additionalinfoitem.dart';
//import 'package:weather_app/envdata.dart';
import 'weather_forecast_item.dart';
import 'package:http/http.dart' as http;


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getWeatherData();
  }
  Future getWeatherData() async{
    try{final res = await http.get(Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?q=London&APPID=5a1139a980e31152039d863a204837be '
    ));
    final data = jsonDecode(res.body);
    if (data['cod'] != 200){
      throw 'an error occured';

    } 
    print(data['list'][0]['main']['temp']);
    } catch(e){
      throw e.toString();
    }
   //String cityName = 'London';
  
  } 

  */

// Stateful Widget of Previous Code

/*


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;



  Future<Map<String, dynamic>> getCurrentWeather() async {

*/

// HourlyForecast(
//                     time: '4:00',
//                     icon: Icons.sunny,
//                     temp: '300°F',
//                   ),
//                   HourlyForecast(
//                     time: '5:00',
//                     icon: Icons.wb_cloudy,
//                     temp: '300°F',
//                   ),
//                   HourlyForecast(
//                     time: '6:00',
//                     icon: Icons.wb_incandescent,
//                     temp: '300°F',
//                   ),
//                   HourlyForecast(
//                     time: '7:00',
//                     icon: Icons.wb_twilight,
//                     temp: '300°F',
//                   ),
//                   HourlyForecast(
//                     time: '8:00',
//                     icon: Icons.wb_iridescent ,
//                     temp: '300°F',
//                   ),
//                   HourlyForecast(
//                     time: '9:00',
//                     icon: Icons.cloud,
//                     temp: '300°F',
//                   ),
