import'package:flutter/material.dart';
import 'package:pinput/pinput.dart';



class otpScreen extends StatefulWidget {
  const otpScreen({super.key});

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Padding(
          padding: const EdgeInsets.only(top:180,left:10,right:10),
          child: Pinput(
            length: 6,
            defaultPinTheme: PinTheme(
              width: 56,
              height: 56,
              textStyle: TextStyle(fontSize: 20, color: Colors.black),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              )),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(fontSize: 20, color: Colors.blue),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(fontSize: 20, color: Colors.green),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(fontSize: 20, color: Colors.red),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red),
                      ),
                    ),
            keyboardType:  TextInputType.number,
                  ),


        )

        ],

      ),
    );
  }
}
