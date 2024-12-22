import 'package:flutter/material.dart';
import 'package:flutter_map/authentication/otp_screen.dart';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:flutter_map/const/urls.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_text_form.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(AppConstants.signupUrl);

      final body = jsonEncode({
        'phone_number': phoneNumberController.text,
        'email': emailController.text,
        'password1': passwordController.text,
        'password2': confirmPasswordController.text,
      });

      try {
        print("Sending POST request to $url with body: $body");
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        print("Response received: ${response.statusCode}, ${response.body}");
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sign-Up Successful!")), );
                //save id in sharedpref
          final data = jsonDecode(response.body);
// Get userId
//           final userId = data['id']; // Ensure it's stored as a string
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setInt('userId', userId);
          // Navigate to OTP screen after signup
          final userId = data['id'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userId);


           Navigator.push(context,  MaterialPageRoute(builder: (context) => OtpScreen()),
           );

        } else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign-Up Failed: ${response.body}")),
          );
        }
      } catch (error) {
        print("Error occurred during sign-up: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again.")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          custom_bg(),
         Padding(
          padding: const EdgeInsets.only(left:16.0,right: 16.0,top:40,bottom: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 31),

                    // Phone Number Input
                    CustomTextFormField(
                      controller: phoneNumberController,
                      labelText: "Phone No.",
                      onChanged: (value){},
                      keyboardType: TextInputType.number,
                      textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter 10 digit Phone Number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email Input
                    CustomTextFormField(
                      controller: emailController,
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password Input
                    CustomTextFormField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      labelText: "Password",
                      textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters long";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Input
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      obscureText: _isObscured,
                      labelText: "Confirm Password",
                      textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      suffixIcon: IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: _isObscured
                            ? const Icon(Icons.visibility_off_outlined, color: Color(0xFFBED1DF))
                            : const Icon(Icons.visibility_outlined, color: Color(0xFFBED1DF)),
                      ),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Submit Button
                    isLoading
                        ? const CircularProgressIndicator()
                        : Custombutton(
                      text: 'Create Account',
                      onPressed: _signUp,
                    ),

                    const SizedBox(height: 18),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text('Already have an account? Log in',style: TextStyle(
                            fontSize: 17,
                            color:Color(0xFFFFFFFF),
                          ),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/term&conditions');
                          },
                          child: const Text(
                            'Terms and conditions',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ],
      ),
    );
  }
}