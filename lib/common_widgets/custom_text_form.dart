import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController ?controller;
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

  final dynamic onChanged;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.controller,
    this.onChanged,
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
      onChanged: onChanged,
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
          borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
