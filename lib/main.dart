import 'package:flutter/material.dart';
import 'package:flutter_map/Theme/theme.dart';
import 'package:flutter_map/provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:flutter_map/provider/theme_provider.dart';
import 'package:flutter_map/routes/routes.dart';
import 'package:flutter_map/screens/route_not_found_screen.dart';
import 'package:provider/provider.dart';

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
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          initialRoute: '/',
          routes: Routes.getRoutes(),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => RouteNotFoundScreen(),
          ),

        );
      }
    );
  }
}

