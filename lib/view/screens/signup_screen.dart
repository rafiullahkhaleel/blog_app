import 'package:blog_app/view/widgets/custom_button.dart';
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
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Colors.green.shade700,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Colors.green.shade700,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'At least 6 characters are required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 40),
                CustomButton(title: 'Register', onPressed: () {
                  if(formKey.currentState!.validate()){
                    passwordController.clear();
                    emailController.clear();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
