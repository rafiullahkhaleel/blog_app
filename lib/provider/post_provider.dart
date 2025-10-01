import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } else {
      debugPrint(" Data saved: ${titleController.text}, ${descriptionController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Blog uploaded successfully")),
      );

      titleController.clear();
      descriptionController.clear();
      _image = null;
      notifyListeners();
    }
  }

}
