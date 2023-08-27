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


// important point to understand :-


//In Flutter, when you create a StatefulWidget, you need to define a corresponding state class 
//that manages the mutable state for that widget. This is done by creating a private class 
//(usually prefixed with an underscore) that extends the State class, parameterized with the widget 
//it's associated with.


class _WeatherScreenState extends State<WeatherScreen> { // private class using "_" in the start of class name 
  
  //extends State<WeatherScreen>: This indicates that _WeatherScreenState extends the generic 
  //State class and is associated with the WeatherScreen widget. This linkage between the widget 
  //and its corresponding state class is important for Flutter to manage the widget's state.

  
  double temp = 0;
  //int tempCelcius = 0;

  // The state class is responsible for two things: holding some data you 
  //can update and building the UI using that data.
  // The state class typically includes methods that handle state changes, data updates, and UI rendering.


  @override
  void initState() {   // initState() method to perform setup tasks when the widget is first created
    super.initState(); // super.initState(); is a call to the initState() method of the superclass, which is State<WeatherScreen>
    getWeatherData();  // used to fectch the weather data 
  }

  Future<Map<String, dynamic>> getWeatherData() async {

    // async :- This keyword is used to define that the function will perform asynchronous operations.
    // It allows you to use await inside the function and indicates that the function
    // won't block the execution of other code while waiting for asynchronous tasks to complete.

    try {
      String cityName = 'Lucknow';

      // The await keyword is used to pause the execution of the code until 
      //the HTTP request is complete and a response is received from the server.

      final res = await http.get( 
        Uri.parse( 
          
          // Uri.parse function is used to create a Uri object from a string 
          //representation of a URI (Uniform Resource Identifier). 

          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherapikey',
        ),
      );


      //final data = jsonDecode(res.body);, decodes the JSON response from the server into a Dart map, 
      //allowing you to access the weather-related data in a structured way.

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
      throw e.toString(); // try and catch are used for exeption handling if any error occurs 
                          // then try and catch reflects that error on the debug console 
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

        // Future is a core concept in asynchronous programming that represents a value or an error 
        //that will be available at some point in the future. It's used to work with operations 
        //that might take time to complete, such as fetching data from a network

        future: getWeatherData(),

        // builder: (context, snapshot) { ... }: This is the callback function that defines
        // how the UI should be built based on the status of the Future. It receives two parameters:
        // context: The BuildContext of the widget.
        // snapshot: A snapshot of the current state of the Future.

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {

            // snapshot :- . The snapshot contains information about whether the asynchronous operation 
            //is still in progress, has completed successfully, or has encountered an error.

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


// Previous Code


/*



HourlyForecast(
                    time: '4:00',
                    icon: Icons.sunny,
                    temp: '300°F',
                  ),
                  HourlyForecast(
                    time: '5:00',
                    icon: Icons.wb_cloudy,
                    temp: '300°F',
                  ),
                  HourlyForecast(
                    time: '6:00',
                    icon: Icons.wb_incandescent,
                    temp: '300°F',
                  ),
                  HourlyForecast(
                    time: '7:00',
                    icon: Icons.wb_twilight,
                    temp: '300°F',
                  ),
                  HourlyForecast(
                    time: '8:00',
                    icon: Icons.wb_iridescent ,
                    temp: '300°F',
                  ),
                  HourlyForecast(
                    time: '9:00',
                    icon: Icons.cloud,
                    temp: '300°F',
                  ),
 


*/


