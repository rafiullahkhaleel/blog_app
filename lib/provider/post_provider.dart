import 'dart:io';

import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _image;
  File? get image => _image;
  set mage(File? value) {
    _image = value;
    notifyListeners();
  }
}
