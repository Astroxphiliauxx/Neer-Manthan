import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFB098A4),
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(color: Colors.black54)
      ),

      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(color: Colors.teal),
          iconTheme: IconThemeData(color: Colors.pink)
      ),

      home: const HomeScreen(),
    );
  }
}

