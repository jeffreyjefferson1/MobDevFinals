import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String LabelText;
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final VoidCallback onTap;
  final TextEditingController controller;

  PasswordField({
    required this.LabelText,
    required this.hintText,
    required this.iconData,
    required this.obscureText,
    required this.onTap,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.lock),
        ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        ),
        labelText: LabelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))),
    );
  }
}
