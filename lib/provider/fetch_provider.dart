import 'package:blog_app/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/screens/auth/register_screen.dart';

class FetchProvider extends ChangeNotifier {
  TextEditingController filterController = TextEditingController();
  List<PostModal> _originalData = [];
  List<PostModal> get originalData => _originalData;

  List<PostModal> _snapshot = [];
  List<PostModal> get snapshot => _snapshot;

  String? _error;
  String? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await FirebaseFirestore.instance.collection('data').get();
      _originalData =
          data.docs.map((doc) {
            return PostModal.fromJson(doc.data());
          }).toList();
      _snapshot = _originalData;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filter(String search) {
    if (search.isEmpty) {
      _snapshot = _originalData;
      notifyListeners();
    } else {
      _snapshot =
          _originalData
              .where(
                (doc) => doc.title.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
      notifyListeners();
    }
  }

}
