import 'package:flutter/material.dart';
import 'package:flutter_map/common_widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final int?id;
  const OtpScreen({super.key, this.id});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        // fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/RECTANGLE.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80), // Spacing from top
                  const Text(
                    'Verify your phone',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'number',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    ' We’ve sent an SMS with an ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    '       activation code to your number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.id as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 20,right:20),
                    child: Pinput(
                      length: 4,
                      defaultPinTheme: PinTheme(
                        width: 71,
                        height: 61,
                        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 71,
                        height: 58,
                        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 71,
                        height: 61,
                        textStyle: const TextStyle(fontSize: 20, color: Colors.green),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 71,
                        height: 61,
                        textStyle: const TextStyle(fontSize: 20, color: Colors.red),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('I didn\'t receive a code',style: TextStyle(
                        fontSize: 14,
                        color: Color(0xB3FFFFFF),
                      ),
                      ),
                      TextButton(onPressed:(){
                        //resend code

                      }, child: Text('Resend',
                      style: TextStyle(
                        fontSize: 14,
                        color:Color(0xFFFFFFFF)
                      ),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
