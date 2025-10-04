import 'package:blog_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.sizeOf(context).height * .07,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.mainColor,
        ),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.mainTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
      ),
    );
  }
}
