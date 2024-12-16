import 'package:flutter/material.dart';
import 'package:flutter_map/authentication/login_screen.dart';
import 'package:flutter_map/authentication/otp_screen.dart';
import 'package:flutter_map/provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:flutter_map/provider/theme_provider.dart';
import 'package:flutter_map/screens/full_map.dart';
import 'package:flutter_map/screens/home2.dart';
import 'package:flutter_map/screens/home_screen_agra.dart';
import 'package:flutter_map/screens/route_not_found_screen.dart';
import 'package:flutter_map/screens/splash_screen.dart';
import 'package:flutter_map/screens/theme_selector.dart';
import 'package:provider/provider.dart';
import 'authentication/sign_up_screen.dart';
import 'common_widgets/extra.dart';
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

            '/':(context)=> splashScreen(),
              '/signUp':(context)=>signUpScreen(),
              '/login':(context)=>const LoginScreen(),
              '/home':(context)=>const HomeScreenAgra(),
              '/theme': (context)=> const ThemeSelector(),
              '/fullMap': (context)=> const FullScreenMap(),
               '/otp':(context)=>const OtpScreen(),
              '/extra':(context)=>DistrictWellCodeApp2(),
            '/home2':(context)=>DistrictWellCodeApp(),

          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => RouteNotFoundScreen(),
          ),

        );
      }
    );
  }
}

