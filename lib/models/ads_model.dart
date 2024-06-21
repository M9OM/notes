import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String url;

  AdModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  factory AdModel.fromFirestore(Map<String, dynamic> data) {
    return AdModel(
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      url: data['url'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'url': url,
    };
  }
}
