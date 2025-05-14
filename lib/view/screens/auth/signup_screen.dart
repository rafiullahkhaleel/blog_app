import 'package:blog_app/view/widgets/custom_button.dart';
import 'package:blog_app/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth/signup_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context, listen: false);
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
        key: provider.formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 40,
              children: [
                CustomField(
                  labelText: 'Email',
                  controller: provider.emailController,
                  icon: Icon(Icons.email_outlined),
                  emptyError: 'Please enter your Email',
                ),
                CustomField(
                  labelText: 'Password',
                  controller: provider.passwordController,
                  icon: Icon(Icons.password_outlined),
                  emptyError: 'Please enter your Password',
                ),
                Consumer<SignUpProvider>(
                  builder: (context, provider, child) {
                    return CustomButton(
                      title: 'Register',
                      isLoading: provider.isLoading,
                      onPressed: () {
                        if (provider.formKey.currentState!.validate()) {
                          provider.signUp(context);
                        }
                      },
                    );
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
