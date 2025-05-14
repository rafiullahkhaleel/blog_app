import 'package:blog_app/firebase_options.dart';
import 'package:blog_app/provider/auth/login_provider.dart';
import 'package:blog_app/provider/auth/signup_provider.dart';
import 'package:blog_app/view/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        home: const RegisterScreen(),
      ),
    );
  }
}
