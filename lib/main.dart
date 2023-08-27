import 'package:flutter/material.dart';
import 'package:weather_app/weatherscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  //key parameter is used to provide a unique identifier for the widget, which helps Flutter to differentiate between widgets with the same type and to maintain the state of the widget.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherScreen(),
    );
  }
}



 /*

      ).copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          //elevation: 0,
          iconTheme:IconThemeData(
            color: Colors.white,
          ),
        )

       */
