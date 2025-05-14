import 'package:blog_app/provider/auth/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
                Consumer<LoginProvider>(
                  builder: (context, provider, child) {
                    return CustomButton(
                      title: 'Login',
                      isLoading: provider.isLoading,
                      onPressed: () {
                        if (provider.formKey.currentState!.validate()) {
                          provider.login(context);
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
