import 'dart:io';
import 'package:blog_app/model/post_model.dart';
import 'package:blog_app/utils/utils.dart';
import 'package:blog_app/view/screens/home_screen.dart';
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
    if (_image == null && _imageUrl == null) {
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
        titleController.clear();
        descriptionController.clear();
        _image = null;
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  String? _oldTitle;
  String? _oldDescription;
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  bool _isEditeMode = false;
  bool get isEditeMode => _isEditeMode;
  String? docsId;

  void forEdit(PostModal data) {
    _imageUrl = data.imageUrl;
    titleController.text = data.title;
    descriptionController.text = data.description;
    _isEditeMode = true;

    _oldTitle = data.title.trim();
    _oldDescription = data.description.trim();
  }

  bool editValidation() {
    final bool isTitleSame = titleController.text.trim() == _oldTitle;
    final bool isDescriptionSame =
        descriptionController.text.trim() == _oldDescription;
    final bool isImageSame = _image == null;
    return isTitleSame && isDescriptionSame && isImageSame;
  }

  Future<void> updateData(BuildContext context) async {
    if (validateInputs() != null) {
      Utils.snackMessage(context, validateInputs()!);
      return;
    } else if (editValidation()) {
      Utils.snackMessage(context, 'No changes to update.');
      Navigator.of(context).pop();
      return;
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        String? imageUrl;
        if (_image != null) {
          final String path = DateTime.now().millisecondsSinceEpoch.toString();
          UploadTask uploadTask = FirebaseStorage.instance
              .ref()
              .child('images')
              .child(path)
              .putFile(_image!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();

        } else {
          imageUrl = _imageUrl;
        }

        if(_imageUrl != null){
          await FirebaseStorage.instance.refFromURL(_imageUrl!).delete();
        }

        await FirebaseFirestore.instance.collection('data').doc(docsId).update({
          'imageUrl': imageUrl,
          'title': titleController.text,
          'description': descriptionController.text,
          'isEdit': 'Edited',
          'createAt': Timestamp.now(),
        });
        titleController.clear();
        descriptionController.clear();
        _image = null;
        _imageUrl = null;
        _isEditeMode = false;
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
