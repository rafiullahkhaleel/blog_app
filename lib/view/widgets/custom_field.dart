import 'package:blog_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Icon? icon;
  final String? emptyError;
  final String? lengthError;
  final int? maxLines;
  final int? minLines;
    final ValueChanged? onChanged;
  const CustomField({
    super.key,
    this.controller,
    this.labelText,
    this.icon,
    this.emptyError,
    this.lengthError,
    this.maxLines,
    this.minLines,  this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.mainColor),
        prefixIcon: icon,
        prefixIconColor: AppColors.mainColor,
      ),
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
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
