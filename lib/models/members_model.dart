import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String uid;
  late final bool isAdmin;
  final Timestamp timestamp;

  Member({
    required this.uid,
    required this.isAdmin,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'isAdmin': isAdmin,
      'timestamp': timestamp,
    };
  }

  // Create a Member object from a map (e.g., Firebase snapshot)
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      uid: map['uid'],
      isAdmin: map['isAdmin'],
      timestamp: map['timestamp'],
    );
  }
}
