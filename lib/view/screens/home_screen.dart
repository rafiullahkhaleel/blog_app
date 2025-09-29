import 'package:blog_app/view/screens/post_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostScreen()));
            },
            icon: Icon(Icons.add, color: Colors.white,size: 28,),
          ),
          SizedBox(width: 5,)
        ],
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
    );
  }
}
