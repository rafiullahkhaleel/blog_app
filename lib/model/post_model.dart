import 'package:cloud_firestore/cloud_firestore.dart';

class PostModal {
  final String title;
  final String description;
  final String imageUrl;
  final String isEdit;
  final String docsId;
  final DateTime createAt;

  PostModal({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isEdit,
    required this.docsId,
    required this.createAt,
  });

  factory PostModal.fromJson(Map<String, dynamic> json) {
    return PostModal(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isEdit: json['isEdit'] ?? '',
      docsId: json['docsId'] ?? '',
      createAt:
          (json['createAt'] is Timestamp)
              ? (json['createAt'] as Timestamp).toDate()
              : DateTime(1970),
    );
  }
}
