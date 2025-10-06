import 'package:blog_app/model/post_model.dart';
import 'package:blog_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final Map<String, String> _selectedItems = {};
  Map<String, String> get selectedItems => _selectedItems;
  bool get isSelectionMode => _selectedItems.isNotEmpty;

  void addIdsForDelete(String id, String imageUrl) {
    if (_selectedItems.containsKey(id)) {
      _selectedItems.remove(id);
    } else {
      _selectedItems[id] = imageUrl;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  Future<void> delete(BuildContext context) async {
    for (var entry in selectedItems.entries) {
      final id = entry.key;
      final image = entry.value;
      try {
        await FirebaseFirestore.instance.collection('data').doc(id).delete();
        await FirebaseStorage.instance.refFromURL(image).delete();
      } catch (e) {
        Utils.snackMessage(context, 'ERROR OCCURRED $e');
      }
    }
    _snapshot.removeWhere((item){
     return _selectedItems.keys.contains(item.docsId);
    });
    clearSelection();
    notifyListeners();
  }
}
