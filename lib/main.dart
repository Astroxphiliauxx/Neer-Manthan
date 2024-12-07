import 'package:flutter/material.dart';
import 'package:flutter_map/authentication/loginScreen.dart';
import 'package:flutter_map/authentication/otpScreen.dart';
import 'package:flutter_map/features/theme.dart';
import 'package:flutter_map/provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:flutter_map/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'authentication/signUpScreen.dart';
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

        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/':(context)=>const otpScreen(),
          '/signUp':(context)=>signUpScreen(),
          '/login':(context)=>const LoginScreen(),
          '/home':(context)=>const HomeScreen(),

        }
    );
  }
}

