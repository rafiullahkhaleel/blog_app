import 'package:blog_app/provider/fetch_provider.dart';
import 'package:blog_app/view/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (_) => FetchProvider()..fetch(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blog', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => PostScreen()));
              },
              icon: Icon(Icons.add, color: Colors.white, size: 28),
            ),
            SizedBox(width: 5),
          ],
          backgroundColor: Colors.green.shade700,
          centerTitle: true,
        ),
        body: Consumer<FetchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (provider.error != null) {
              return Center(
                child: Text(
                  'ERROR OCCURRED: ${provider.error}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (provider.snapshot.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: provider.snapshot.length,
                itemBuilder: (context, index) {
                  final data = provider.snapshot[index];
                  final createAt = data.createAt;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            data.imageUrl,
                            height: height * .3,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            data.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('hh : mm a').format(createAt),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM, yyyy').format(createAt),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5),
                        Text(
                          data.description,
                          style: TextStyle(color: Colors.black,fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
