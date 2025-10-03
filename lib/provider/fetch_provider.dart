import 'package:blog_app/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchProvider extends ChangeNotifier {
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
      _snapshot =
          data.docs.map((doc) {
            return PostModal.fromJson(doc.data());
          }).toList();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
