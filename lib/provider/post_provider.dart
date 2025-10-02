import 'dart:io';
import 'package:blog_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _image;
  File? get image => _image;

  Future<void> imagePicker(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      debugPrint('Picked');
      notifyListeners();
    } else {
      debugPrint('No image selected');
    }
    Navigator.of(context).pop();
  }

  String? validateInputs() {
    if (_image == null) {
      return 'Image is required';
    } else if (titleController.text.trim().isEmpty) {
      return 'Title is required';
    } else if (descriptionController.text.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  Future<void> saveData(BuildContext context) async {
    final errorMessage = validateInputs();
    if (errorMessage != null) {
      Utils.snackMessage(context, errorMessage);
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        final String path = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(path)
            .putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('data').doc();
        await documentReference.set({
          'imageUrl': imageUrl,
          'title': titleController.text,
          'description': descriptionController.text,
          'docsId': documentReference.id,
          'createAt': Timestamp.now(),
        });

        Utils.snackMessage(context, 'Blog uploaded successfully');

        titleController.clear();
        descriptionController.clear();
        _image = null;
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }finally{
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
