import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_map/authentication/otp_screen.dart';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_text_form.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadUserId();
  // }
  //
  // Future<void> _loadUserId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userId = prefs.getInt('userId');
  //   });
  // }
  //
  // Future<void> login() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       isLoading = true;
  //     });
  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Prepare the request body
      final body = jsonEncode({
        'phone_number': phoneController.text,
        'password': passwordController.text,
      });

      try {
        // Define the API URL
        final url = Uri.parse("http://10.0.2.2:8000/user/login/");
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        // Handle response
        if (response.statusCode == 200 ) {
          final responseData = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful!")),
          );

          // Navigate to OTP screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OtpScreen()),
          );
        } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['error'] ?? "Login Failed!";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (error) {
        print('Error occurred: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred!")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //     final body = jsonEncode({
  //       'phone_number': phoneController.text,
  //       'password': passwordController.text,
  //     });
  //
  //     try {
  //       final url = Uri.parse("http://10.0.2.2:8000/user/login/");
  //       final response = await http.post(
  //         url,
  //         headers: {'Content-Type': 'application/json'},
  //         body: body,);
  //       print(response.body);
  //
  //       if (response.statusCode == 201) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Login Successful!")),);
  //         //Navigate to otp-verify screen
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(id: userId!)));
  //
  //       } else {
  //         print(response.statusCode);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Login Failed!")),
  //         );
  //       }
  //     } catch (error) {
  //       print('Error occurred: $error');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("An error occurred!")),
  //       );
  //     } finally {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          custom_bg(),
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 250, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 34),
                  

                 const Text(
                  'Phone number',
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFFFFFF),
                 ),
                   ),
CustomTextFormField(
  controller: phoneController,
  labelText: "Phone No.",
  onChanged: (value) {},
  keyboardType: TextInputType.number,
  textStyle: const TextStyle(
    color: Color(0xFFFFFFFF),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Please enter 10 digit Phone Number";
    }
    return null;
  },
),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                       Navigator.pushNamed(context, '/forgotPassword');
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  isLoading
                      ?  CircularProgressIndicator()
                      : Custombutton(text: 'Log in',onPressed: (){
                              login();
                  },),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed((context), '/signUp');
                        // Navigate to Sign Up Screen
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
