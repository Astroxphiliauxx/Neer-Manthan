import 'package:flutter/material.dart';
import 'package:flutter_map/authentication/loginScreen.dart';
import 'package:flutter_map/provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:flutter_map/provider/theme_provider.dart';
import 'package:flutter_map/screens/route_not_found_screen.dart';
import 'package:flutter_map/screens/splash_screen.dart';
import 'package:flutter_map/screens/theme_selector.dart';
import 'package:provider/provider.dart';
import 'authentication/signUpScreen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapState()),
        ChangeNotifierProvider(create: (_) => LocationState()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final themeChanger= Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeChanger.themeMode,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                color: Colors.blueAccent,
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
              scaffoldBackgroundColor: Colors.black54,
              appBarTheme: const AppBarTheme(color: Colors.blueAccent),
              iconTheme: const IconThemeData(color: Colors.pink)
          ),
          initialRoute: '/',
          routes: {
              '/':(context)=>const splashScreen(),
              '/signUp':(context)=>signUpScreen(),
              '/login':(context)=>const LoginScreen(),
              '/home':(context)=>const HomeScreen(),
              '/theme': (context)=> const ThemeSelector(),

          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => RouteNotFoundScreen(),
          ),

        );
      }
    );
  }
}

