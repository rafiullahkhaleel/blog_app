import 'package:blog_app/view/widgets/custom_button.dart';
import 'package:blog_app/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 40,
              children: [
                CustomField(
                  labelText: 'Email',
                  icon: Icon(Icons.email_outlined),
                ),
                CustomField(
                  labelText: 'Password',
                  icon: Icon(Icons.password_outlined),
                ),
                CustomButton(
                  title: 'Register',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      passwordController.clear();
                      emailController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
