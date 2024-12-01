import 'package:flutter/material.dart';
import 'package:flutter_map/provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapState()),
        ChangeNotifierProvider(create: (_) => LocationState()),
      ],
      child: const MyApp(),
    ),
  );
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
          appBarTheme: AppBarTheme(
            color: Colors.black54,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 25
            ),
            iconTheme: IconThemeData(color: Colors.white)
          ),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme()
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

