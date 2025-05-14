import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Icon? icon;
  final String? emptyError;
  final String? lengthError;
  const CustomField({
    super.key,
    this.controller,
    this.labelText,
    this.icon,
    this.emptyError,
    this.lengthError,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.green.shade700),
        prefixIcon: icon,
        prefixIconColor: Colors.green.shade700,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return emptyError;
        } else if (value.length < 6) {
          return lengthError;
        } else {
          return null;
        }
      },
    );
  }
}
