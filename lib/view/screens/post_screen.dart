import 'package:blog_app/provider/post_provider.dart';
import 'package:blog_app/view/widgets/custom_button.dart';
import 'package:blog_app/view/widgets/custom_dialog.dart';
import 'package:blog_app/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Post Blog', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<PostProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog();
                        },
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          provider.image != null
                              ? Image.file(provider.image!,fit: BoxFit.cover,)
                              : Center(child: Icon(Icons.photo, size: 50)),
                    ),
                  ),
                  CustomField(
                    labelText: 'Title',
                    controller: provider.titleController,
                    icon: Icon(Icons.title),
                  ),
                  CustomField(
                    labelText: 'Description',
                    controller: provider.descriptionController,
                    icon: Icon(Icons.description_outlined),
                    maxLines: 5,
                    minLines: 1,
                  ),
                  CustomButton(
                    isLoading: provider.isLoading,
                    title: ('Upload'),
                    onPressed: () {
                      provider.saveData(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
