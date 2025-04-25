import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;
  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height*.065,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.green.shade700
        ),
        child: Center(
          child: Text(title,style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400

          ),),
        ),
      ),
    );
  }
}
