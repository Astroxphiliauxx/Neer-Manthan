
import 'package:flutter/cupertino.dart';

import '../authentication/login_screen.dart';
import '../authentication/otp_screen.dart';
import '../authentication/sign_up_screen.dart';
import '../common_widgets/extra.dart';
import '../screens/full_map.dart';
import '../screens/home2.dart';
import '../screens/home_screen_agra.dart';
import '../screens/theme_selector.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => HomeScreenAgra(),
      '/signUp': (context) => SignUpScreen(),
      '/login': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreenAgra(),
      '/theme': (context) => const ThemeSelector(),
      '/fullMap': (context) => const FullScreenMap(),
      '/otp': (context) => const OtpScreen(),
      '/extra': (context) => DistrictWellCodeApp2(),
      '/home2': (context) => DistrictWellCodeApp(),
    };
  }
}
