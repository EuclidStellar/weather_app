import 'package:flutter/material.dart';
import 'package:weather_app/weatherscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
