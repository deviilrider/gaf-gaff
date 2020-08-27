import 'package:flutter/material.dart';
import 'package:gafgaff/Constants/colors.dart';

// ignore: must_be_immutable
class CostumTextField extends StatelessWidget {
  String hint;
  String label;
  TextEditingController controller;
  Icon prefixIcon;
  IconButton suffixIcon;
  bool obscureValue;
  Widget prefix;
  TextInputType keyboardType;
  Function validator;
  String error;
  CostumTextField(
      {this.hint,
      this.label,
      this.controller,
      this.obscureValue,
      this.prefixIcon,
      this.prefix,
      this.keyboardType,
      this.suffixIcon,
      this.validator,
      this.error});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureValue,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorText: error,
        helperMaxLines: 2,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefix: prefix,
        filled: true,
        hintText: hint,
        labelText: label,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 0.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: maincolor2),
          borderRadius: BorderRadius.circular(25.7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
    );
  }
}
