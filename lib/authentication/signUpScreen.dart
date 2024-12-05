import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../common_widgets/CustomButton.dart';
import '../common_widgets/CustomTextForm.dart';

class signUpScreen extends StatefulWidget {
  @override
  _signUpScreenState createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phonenumberController = TextEditingController();
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

      final url = Uri.parse('http://127.0.0.1:8000/user/');
      final body = jsonEncode({
        'phone_number': phonenumberController.text,
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
            const SnackBar(content: Text("Sign-Up Successful!")),
          );
          // Navigate to login or home screen
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      color: Color(0xFF1E6091),
                    ),
                  ),
                  const SizedBox(height: 31),

                  // Phone Number Input
                  CustomTextFormField(
                    controller: phonenumberController,
                    labelText: "Phone No.",
                    keyboardType: TextInputType.number,
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
                        child: const Text('Already have an account? Log in'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Terms and conditions',
                          style: TextStyle(
                            color: Color(0xFF184E77),
                            fontSize: 16,
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
    );
  }
}
