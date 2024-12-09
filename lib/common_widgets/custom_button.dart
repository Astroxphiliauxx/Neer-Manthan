import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final VoidCallback? onPressed; // Function parameter
  final String text;

  const Custombutton({Key? key, this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:60,
      child: ElevatedButton(
        style: ButtonStyle(

            backgroundColor:WidgetStatePropertyAll(Color(0xFF82C6F8)) ,
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(10),
                )
            )
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
