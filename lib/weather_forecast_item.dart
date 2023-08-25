import 'dart:ui';
import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast(
      {required this.time, required this.icon, required this.temp, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    icon,
                    size: 32,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    temp,
                    // style: TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
