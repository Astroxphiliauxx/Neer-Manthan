import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.blueAccent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(),
    );
  }


  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black54,
      appBarTheme: const AppBarTheme(
        color: Colors.blueAccent,
      ),
      iconTheme: const IconThemeData(color: Colors.pink),
      textTheme: const TextTheme(),
    );
  }
}
