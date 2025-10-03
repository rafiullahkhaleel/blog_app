import 'package:blog_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../view/screens/home_screen.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _forgotLoading = false;
  bool get forgotLoading => _forgotLoading;

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  void login(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((val) {
            _isLoading = false;
            notifyListeners();
            clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            clear();
          });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ERROR OCCURRED $e')));
    }
  }

  void forgotPassword(BuildContext context) async {
    try {
      _forgotLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      Utils.snackMessage(
        context,
        'Please check your email, a reset link has been sent to you via email.',
      );
    } catch (e) {
      Utils.snackMessage(context, 'ERROR OCCURRED $e');
    } finally {
      _forgotLoading = false;
      notifyListeners();
    }
  }
}
