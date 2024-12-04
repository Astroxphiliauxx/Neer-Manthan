import 'dart:async';

import "package:flutter/material.dart";
import'package:flutter_spinkit/flutter_spinkit.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 4),(){
      Navigator.pushReplacementNamed(context,'/signUp');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:161,
              width:130,
              child: Image.asset("assets/SEOLogo 1.jpg",fit: BoxFit.cover,),
            ),
            const SizedBox(
              height:90,
            ),

            //loading indicator
            const SpinKitCircle(
              color: Color(0xFF1A3665),
              size: 100.0,
            )

          ],
        ),
      ),
    );
  }
}
