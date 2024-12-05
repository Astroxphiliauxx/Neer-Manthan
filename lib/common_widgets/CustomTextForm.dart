import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FontWeight?fontWeight;
  final int maxLines;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fontWeight ,
    this.maxLines = 1,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: textStyle,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFFBED1DF),
          fontSize: 16,
          fontWeight: fontWeight,
        ) ,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1E6091), width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
