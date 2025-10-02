import 'package:cloud_firestore/cloud_firestore.dart';

class PostModal {
  final String title;
  final String description;
  final String imageUrl;
  final String docsId;
  final String createAt;

  PostModal({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.docsId,
    required this.createAt,
  });

 factory PostModal.fromJson(Map<String,dynamic> json){
   return PostModal(
     title: json['title'] ?? '',
     description: json['description'] ?? '',
     imageUrl: json['imageUrl'] ?? '',
     docsId: json['docsId'] ?? '',
     createAt: (json['createAt'] is Timestamp)
         ? (json['createAt'] as Timestamp).toDate().toString()
         : '',
   );

 }
}
