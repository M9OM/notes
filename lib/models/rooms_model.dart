import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/user_model.dart';

class RoomsModel {
  final String imageUrl;
  final String title;
  final String subtitle;

  RoomsModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  static List<RoomsModel> roomsList = [
    RoomsModel(
      imageUrl:
          'https://i.pinimg.com/564x/5f/6b/50/5f6b50ae839f59f5f002d25eb0e42a44.jpg',
      title: 'نقاش حول البرمجة',
      subtitle: 'يتابعون فيديو',
    ),
    RoomsModel(
      imageUrl:
          'https://i.pinimg.com/474x/d4/30/1f/d4301f1c66da24156712b78ecd64507f.jpg',
      title: 'نجرب اللعبة ذي',
      subtitle: 'يتابعون فيديو',
    ),
    RoomsModel(
      imageUrl:
          'https://i.pinimg.com/474x/95/46/96/954696ddda353c1884f259b4576c1e07.jpg',
      title: 'نقاش حول الذكاء الاصطناعي',
      subtitle: 'يستمعون',
    ),
    RoomsModel(
      imageUrl:
          'https://i.pinimg.com/474x/f3/3a/3d/f33a3d54caf67aaed7b95678ec58e51b.jpg',
      title: 'ويش يعني json ؟',
      subtitle: 'يتابعون فيديو',
    ),
    RoomsModel(
      imageUrl:
          'https://i.pinimg.com/474x/f0/82/2e/f0822eea56a4765019741ba64f704846.jpg',
      title: 'تعالوا نطبخ',
      subtitle: 'يستمعون',
    ),
  ];
}

// Define the Rooms class
class Rooms {
  final List<Member> membersId;
  final String roomName;
  final String roomId;
  final String roomType;
  final Timestamp timestamp;
  final String avtarRoomUrl;
  List<UserModel>? membersData; // Add this line

  Rooms({
    required this.membersId,
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.timestamp,
    required this.avtarRoomUrl,
    this.membersData, // Add this line
  });

  // Convert Rooms object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'membersId': membersId.map((member) => member.toMap()).toList(),
      'roomId': roomId,
      'roomName': roomName,
      'roomType': roomType,
      'timestamp': timestamp,
      'avtarRoomUrl': avtarRoomUrl,
    };
  }

  // Create Rooms object from Firestore document
  factory Rooms.fromFirestore(Map<String, dynamic> doc) {
    return Rooms(
      membersId: (doc['membersId'] as List<dynamic>)
          .map((memberDoc) => Member.fromMap(memberDoc as Map<String, dynamic>))
          .toList(),
      roomId: doc['roomId'] ?? '',
      roomName: doc['roomName'] ?? '',
      roomType: doc['roomType'] ?? '',
      timestamp: doc['timestamp'] as Timestamp,
      avtarRoomUrl: doc['avtarRoomUrl'] ?? '',
    );
  }
}
