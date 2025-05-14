import 'package:blog_app/view/screens/auth/login_screen.dart';
import 'package:blog_app/view/screens/auth/signup_screen.dart';
import 'package:blog_app/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/download.png'),
            SizedBox(height: 50,),
            CustomButton(
                title: 'Register',
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>SignupScreen()));
                }),
            SizedBox(height: 50,),
            CustomButton(
                title: 'Login',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                })
          ],
        ),
      ),
      ),
    );
  }
}
