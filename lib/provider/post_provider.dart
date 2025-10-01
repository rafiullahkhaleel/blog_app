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


}
