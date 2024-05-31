import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String userId;
  final Timestamp timestamp;
  final List<Likes> likes;
final String? id;
final String audioUrl;
  Message(
      {required this.text,
      required this.userId,
      required this.timestamp,
      required this.likes, this.id, required this.audioUrl});

  // Convert Message to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'userId': userId,
      'timestamp': timestamp,
      'likes': likes.map((like) => like.toFirestore()).toList(),
    };
  }

  // Create Message from Firestore document
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      id:doc.id,
      text: data['text'] ?? '',
      audioUrl:data['audioUrl']??'',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      likes: (data['likes'] as List)
          .map((like) => Likes.fromFirestore(like as Map<String, dynamic>))
          .toList(),
    );
  }
}


class Likes {
  final String userId;
  final String emoji;

  Likes({required this.userId, required this.emoji});

  // Convert Likes to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'emoji': emoji,
    };
  }

  // Create Likes from Firestore map
  factory Likes.fromFirestore(Map<String, dynamic> data) {
    return Likes(
      userId: data['userId'] ?? '',
      emoji: data['emoji'] ?? '',
    );
  }
}
