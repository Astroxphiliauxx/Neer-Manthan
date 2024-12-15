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
    Timer(const Duration(seconds: 6),(){
      Navigator.pushReplacementNamed(context,'/signUp');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/RECTANGLE.jpg"), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height:160,
                  width:140,
                  child: Image.asset("assets/SEOLogo 1.png",fit: BoxFit.cover,),
                ),
                SizedBox(
                  height:5,
                ),
                Container(
                  height:90,
                  width:150,
                  child: Image.asset("assets/logo2.png",fit: BoxFit.fitWidth,),
                ),
                // Container(
                //   height:32,
                //   width:140,
                //   child: Image.asset("assets/step count.jpg",fit: BoxFit.fitWidth,),
                // ),
                const SizedBox(
                  height:35,
                ),

                //loading indicator
                const SpinKitCircle(
                  color: Color(0xFFFFFFFF),
                  size: 100.0,
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}