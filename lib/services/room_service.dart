import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/follow_service.dart';
import 'package:notes/services/notification_service.dart';
import 'package:notes/utils/enum/RoomType.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Map<String, dynamic>>> getMessagesWithUserData(
      String roomId, Timestamp timeNow) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Map<String, UserModel> userCache =
        {}; // خريطة للتخزين المؤقت لبيانات المستخدمين

    return firestore
        .collection('rooms/$roomId/messages')
        .orderBy('timestamp', descending: true)
        .where('timestamp',
        
        
        isGreaterThanOrEqualTo: timeNow 
        
        
        )
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> messagesWithUserData = [];
      List<Future<DocumentSnapshot>> userFutures = [];

      // جمع معرفات المستخدمين من الرسائل غير الموجودة في التخزين المؤقت
      Set<String> userIds =
          snapshot.docs.map((doc) => doc['userId'] as String).toSet();
      userIds.removeWhere((id) => userCache.containsKey(id));

      // جلب بيانات المستخدمين في طلبات متوازية
      for (var userId in userIds) {
        userFutures.add(firestore.collection('users').doc(userId).get());
      }

      List<DocumentSnapshot> userSnapshots = await Future.wait(userFutures);

      // تحديث التخزين المؤقت ببيانات المستخدمين الجديدة
      for (var userSnapshot in userSnapshots) {
        UserModel user = UserModel.fromFirestore(
            userSnapshot.data() as Map<String, dynamic>);
        userCache[userSnapshot.id] = user;
      }

      // إعداد الرسائل مع بيانات المستخدمين
      for (var doc in snapshot.docs) {
        Message message = Message.fromFirestore(doc);
        UserModel user = userCache[message.userId]!;

        messagesWithUserData.add({
          'message': message,
          'user': user,
        });
      }

      return messagesWithUserData;
    });
  }





  Future<void> addLikeRoom(String roomId, String userId) async {
    final roomRef = _db.collection('rooms').doc(roomId);

    await roomRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeLikeRoom(String roomId, String userId) async {
    final roomRef = _db.collection('rooms').doc(roomId);

    await roomRef.update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }



//  Stream<List<RoomsModel>> getRooms(String roomId) {
//     return _db
//         .collection('rooms/$roomId')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return Rooms.fromFirestore(doc);
//       }).toList();
//     });
//   }

Stream<List<Rooms?>> getAllRooms() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final StreamController<List<Rooms?>> streamController = StreamController();

  Future<void> fetchRooms() async {
    try {
      // Get all room documents
      QuerySnapshot roomSnapshots = await firestore.collection('rooms').orderBy('timestamp', descending: true).get();
      List<Rooms?> rooms = [];

      for (DocumentSnapshot roomSnapshot in roomSnapshots.docs) {
        if (roomSnapshot.exists) {
          Rooms room = Rooms.fromFirestore(roomSnapshot.data() as Map<String, dynamic>);

          // Get the members' data
          List<UserModel> membersData = [];
          for (var member in room.membersId) {
            DocumentSnapshot userSnapshot = await firestore.collection('users').doc(member.uid).get();
            if (userSnapshot.exists) {
              UserModel user = UserModel.fromFirestore(userSnapshot.data() as Map<String, dynamic>);
              user.isAdmin = member.isAdmin ?? false;
              membersData.add(user);
            }
          }

          // Include the members' data in the room object or handle it separately
          room.membersData = membersData;
          rooms.add(room);
        } else {
          rooms.add(null);
        }
      }

      // Add the rooms to the stream
      streamController.add(rooms);
    } catch (e) {
      print('Error fetching rooms: $e');
      streamController.addError(e);
    }
  }

  // Fetch the rooms initially
  fetchRooms();

  // Return the stream
  return streamController.stream;
}


// Updated getRoomById function
  Stream<Rooms?> getRoomById(String roomId) async* {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Listen to real-time updates of the room document
      await for (DocumentSnapshot roomSnapshot
          in firestore.collection('rooms').doc(roomId).snapshots()) {
        if (roomSnapshot.exists) {
          Rooms room =
              Rooms.fromFirestore(roomSnapshot.data() as Map<String, dynamic>);

          // Fetch members' data
          List<UserModel> membersData = [];
          for (var member in room.membersId) {
            DocumentSnapshot userSnapshot =
                await firestore.collection('users').doc(member.uid).get();
            if (userSnapshot.exists) {
              UserModel user = UserModel.fromFirestore(
                  userSnapshot.data() as Map<String, dynamic>);

              user.isAdmin = member.isAdmin ?? false;
              membersData.add(user);
            }
          }

          // Include the members' data in the room object or handle it separately
          room.membersData = membersData;

          yield room;
        } else {
          yield null;
        }
      }
    } catch (e) {
      print('Error fetching room: $e');
      yield null;
    }
  }

  Stream getRooms(String roomId) {
    return _db
        .collection('rooms/$roomId')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> lastMessage(String roomId) async {
    await _db.collection('rooms').doc(roomId).update({
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMessage(String roomId, String text, String userId) async {
    Message newMsg = Message(
        likes: [],
        userId: userId,
        text: text,
        timestamp: Timestamp.now(),
        audioUrl: '');
    try {
      await _db.collection('rooms/$roomId/messages').add(newMsg.toFirestore());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reportRoom(String roomId, String uid)async{


    await _db.collection('report').add({
      'timestamp': FieldValue.serverTimestamp(),
      'roomId': roomId,
      'userId':uid,
      'report':'ابلاغ عن غرفة'

    });


  }

  Future<void> createRoom(
      String roomName, String roomId, String adminId, String avtarRoomUrl,
      {required String roomType}) async {
    List<UserModel> failedFollowers =
        await FollowService().getFollowersData(adminId);
    List<String> playerId = [];
    for (var i = 0; i < failedFollowers.length; i++) {
      playerId.add(failedFollowers[i].playerId ??
          'ce20d459-4180-41a3-a326-bf3b9a320e12');
    }
    print(playerId);
    final currentUserData = await AuthService().getCurrentUserData();

    NotificationsService().sendNotification(
        playerId, 'انضم الى مكعب بعنوان $roomName', currentUserData!.username!);
 Rooms room = Rooms(
        membersId: [Member(uid: adminId, isAdmin: true, timestamp: Timestamp.now())],
        roomId: roomId,
        roomName: roomName,
        roomType: roomType,
        timestamp: Timestamp.now(),
        avtarRoomUrl: avtarRoomUrl,
        videoId: '',
        likes: [],
      );
    await _db.collection('rooms').doc(roomId).set(room.toFirestore());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getRoomStream(String roomId) {
    return _db.collection('rooms').doc(roomId).snapshots();
  }

  Future<Rooms?> getUserDataRooms(String roomId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> roomSnapshot =
          await FirebaseFirestore.instance
              .collection('rooms')
              .doc(roomId)
              .get();

      if (roomSnapshot.exists) {
        Rooms room = Rooms.fromFirestore(roomSnapshot.data()!);

        // Fetch members' data
        List<UserModel> membersData = [];
        for (var member in room.membersId) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(member.uid)
                  .get();
          if (userSnapshot.exists) {
            UserModel user = UserModel.fromFirestore(userSnapshot.data()!);
            user.isAdmin = member.isAdmin ?? false;
            membersData.add(user);
          }
        }

        // Include the members' data in the room object
        room.membersData = membersData;

        return room;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching room data: $e');
      return null;
    }
  }
void assignAdminToOldestMember(Rooms room) {
  if (room.membersId.isNotEmpty) {
    // Sort members by timestamp
    room.membersId.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Create a new list of members with the updated isAdmin status
    List<Member> updatedMembers = room.membersId.asMap().entries.map((entry) {
      int idx = entry.key;
      Member member = entry.value;
      return Member(
        uid: member.uid,
        isAdmin: idx == 0, // Set isAdmin to true for the oldest member (first in sorted list)
        timestamp: member.timestamp,
      );
    }).toList();

    // Update the room's membersId list
    room.membersId
      ..clear()
      ..addAll(updatedMembers);
  }
}




  Future<void> setVideo(String roomId, String videoId) async {
    await _db.collection('rooms').doc(roomId).update({
      'videoId': videoId,
    });
  }

Future<void> joinRoom(String roomId, String userId) async {
  // تعريف العضو الجديد
  Member member = Member(uid: userId, isAdmin: false, timestamp: Timestamp.now());

  // الحصول على بيانات مسؤول الغرفة
  final getDataOfRoomAdmin = await getUserDataRooms(roomId);

  if (getDataOfRoomAdmin != null) {
    // الحصول على بيانات المستخدم الحالي
    final currentUserData = await AuthService().getCurrentUserData();

    // التحقق مما إذا كان المستخدم موجودًا بالفعل في قائمة الأعضاء
    bool isUserAlreadyInRoom = getDataOfRoomAdmin.membersId.any((member) => member.uid == userId);

    if (!isUserAlreadyInRoom) {
      // إذا لم يكن المستخدم موجودًا بالفعل، قم بإضافته
      List<String> playerId = [];

      // تحقق مما إذا كانت قائمة أعضاء الغرفة غير فارغة قبل الوصول إلى طولها
      if (getDataOfRoomAdmin.membersData != null) {
        for (var i = 0; i < getDataOfRoomAdmin.membersData!.length; i++) {
          playerId.add(getDataOfRoomAdmin.membersData![i].playerId ??
              'ce20d459-4180-41a3-a326-bf3b9a320e12');
        }
      }

      // إرسال رسالة الانضمام
      sendMessage(roomId, 'قام بالانضمام ${currentUserData!.username}', userId);

      // تحديث قائمة الأعضاء في الغرفة
      await _db.collection('rooms').doc(roomId).update({
        'membersId': FieldValue.arrayUnion([member.toMap()]),
      });

      // إرسال الإشعارات إذا كانت قائمة playerId غير فارغة
      if (playerId.isNotEmpty && currentUserData != null) {
        NotificationsService().sendNotification(
          playerId,
          'قام بالانضمام ${currentUserData.username}',
          '',
        );
      }
    } else {
      print('User is already in the room.');
    }
  } else {
    print('Error: Failed to get room admin data.');
  }
}
Future<void> leaveRoom(String roomId, String memberId) async {
  try {
    // Retrieve the room document
    DocumentSnapshot roomSnapshot = await _db.collection('rooms').doc(roomId).get();

    // Check if the room exists and contains the member to be removed
    if (roomSnapshot.exists && roomSnapshot.data() != null) {
      final roomData = roomSnapshot.data() as Map<String, dynamic>;

      // Get the current list of members
      List<dynamic> members = List.from(roomData['membersId'] as List<dynamic>);

      // Filter out all members with the specified uid
      members.removeWhere((member) => member['uid'] == memberId);

      // Send a message indicating the member left
      await sendMessage(roomId, 'قام بالمغادرة', memberId);

      // Update the room document with the new list of members
      await _db.collection('rooms').doc(roomId).update({
        'membersId': members,
      });

      print('Member(s) removed successfully');
    } else {
      print('Error: Room not found.');
    }
  } catch (error) {
    print('Error leaving room: $error');
    // Handle error as needed
  }
}



  Future<void> sendVoiceMessage(String filePath, String userId) async {
    try {
      // Upload the audio file to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('voice_messages').child(fileName);
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Create a message object with the audio file URL
      Message newMsg = Message(
        likes: [],
        userId: userId,
        text: '', // empty text for voice message
        audioUrl: downloadURL,
        timestamp: Timestamp.now(),
      );

      // Add the message to Firestore
      await _db.collection('messages').add(newMsg.toFirestore());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reactionMsg(
      Likes emoji, String userId, String docId, String roomId) async {
    try {
      await _db.collection('rooms/$roomId/messages').doc(docId).update({
        'likes': FieldValue.arrayUnion([emoji.toFirestore()]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeReactionMsg(
      Likes emoji, String userId, String docId, String roomId) async {
    try {
      await _db.collection('rooms/$roomId/messages').doc(docId).update({
        'likes': FieldValue.arrayRemove([emoji.toFirestore()]),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

// Showing All Issues
// The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.




class RoomService {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getRoomsHome({DocumentSnapshot? startAfter, int limit = 5, required List<String> followedUserIds}) async {
    try {
      Query query = _firestore
          .collection('rooms')
          .where('membersId.uid', whereIn: followedUserIds)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot roomSnapshots = await query.get();
      return roomSnapshots.docs;
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<List<DocumentSnapshot>> getRooms({DocumentSnapshot? startAfter, int limit = 5}) async {
    try {
      Query query = _firestore.collection('rooms').orderBy('timestamp', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot roomSnapshots = await query.get();
      return roomSnapshots.docs;
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }
    Future<List<DocumentSnapshot>> getRoomsForFollowedUsers(List<String> followedUserIds, {DocumentSnapshot? startAfter, int limit = 5}) async {
    try {
      Query query = _firestore.collection('rooms')
                      .where('membersId', whereIn: followedUserIds)
                      .orderBy('timestamp', descending: true)
                      .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot roomSnapshots = await query.get();
      return roomSnapshots.docs;
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

}
