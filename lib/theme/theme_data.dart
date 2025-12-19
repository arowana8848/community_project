import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.amber[200],
    fontFamily: 'Open-Sans Bold',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'OpenSans Regular'),
        backgroundColor: Colors.orange,
      ),
    ),
  );
}