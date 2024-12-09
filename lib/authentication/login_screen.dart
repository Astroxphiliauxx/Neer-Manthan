import 'dart:convert';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_text_form.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final body = jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      });

      try {
        final url = Uri.parse('https://example.com/api/login');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,);
        print(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful!")),);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed!")),
          );
        }
      } catch (error) {
        print('Error occurred: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred!")),
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
                    'Email address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: "helloworld@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: " ......",
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters long";
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
                        Navigator.pushNamed(context, '/home');
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
