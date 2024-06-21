import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/user_model.dart';

class Rooms {
  final List<Member> membersId;
  final String roomName;
  final String roomId;
  final String roomType;
  final Timestamp timestamp;
  final String avtarRoomUrl;
  List<UserModel>? membersData;
  final List? likes;
  final String? videoId;
  bool? isPrivate;

  String? password;

  Rooms({
    required this.membersId,
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.timestamp,
    required this.avtarRoomUrl,
    this.videoId,
    this.likes = const [],
    this.membersData,
    this.isPrivate,
    this.password,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'membersId': membersId.map((member) => member.toMap()).toList(),
      'roomId': roomId,
      'roomName': roomName,
      'roomType': roomType,
      'timestamp': timestamp,
      'avtarRoomUrl': avtarRoomUrl,
      'likes': likes,
      'videoId': videoId,
      'isPrivate': isPrivate,
      'password': password,
    };
  }

  factory Rooms.fromFirestore(Map<String, dynamic> doc) {
    return Rooms(
        membersId: (doc['membersId'] as List<dynamic>)
            .map((memberDoc) =>
                Member.fromMap(memberDoc as Map<String, dynamic>))
            .toList(),
        roomId: doc['roomId'] ?? '',
        roomName: doc['roomName'] ?? '',
        roomType: doc['roomType'] ?? '',
        timestamp: doc['timestamp'] as Timestamp,
        avtarRoomUrl: doc['avtarRoomUrl'] ?? '',
        likes: doc['likes'],
        isPrivate: doc['isPrivate'],
        password: doc['password'],
        videoId: doc['videoId']);
  }
}
