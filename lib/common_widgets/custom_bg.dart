import'package:flutter/material.dart';



class custom_bg extends StatelessWidget {
  const custom_bg({super.key, });

  @override
  Widget build(BuildContext context) {
    return  Container(
       height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"), // Replace with your image asset
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
