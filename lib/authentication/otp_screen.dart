import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/const/urls.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = ""; // Variable to store OTP entered by user
  bool isLoading = false;
  int? userId; // To store the userId from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Retrieve the userId directly as an int
      int? retrievedUserId = prefs.getInt('userId');
      if (retrievedUserId != null) {
        setState(() {
          userId = retrievedUserId;
        });
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User ID not found. Please sign up again.")),
        );
      }
    } catch (error) {
      print("Error loading userId: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while loading user data.")),
      );
    }
  }

  Future<void> verifyOtp() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign up again.")),
      );
      return;
    }

    if (otpCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(AppConstants.otpUrl);
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp':otpCode}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified Successfully!")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${responseData['error'] ?? "Invalid OTP!"}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred during verification!")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign up again.")),
      );
      return;
    }
    setState(() {
      isLoading = true;
      otpCode = "";
    });

    try {
      final url = Uri.parse(AppConstants.reOtpUrl);
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Regenarated Successfully")),
        );
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? "Failed to resend OTP!")),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred during OTP resend!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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
                    'We’ve sent an SMS with an ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'activation code to your number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '9258563289',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Pinput(
                      onChanged: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
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
                      const Text(
                        'I didn\'t receive a code',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xB3FFFFFF),
                        ),
                      ),
                      TextButton(
                        onPressed: resendOtp,
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: verifyOtp,
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}