import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:notes/utils/enum/RoomType.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Map<String, dynamic>>> getMessagesWithUserData(String roomId) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  return firestore
      .collection('rooms/$roomId/messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
    List<Map<String, dynamic>> messagesWithUserData = [];

    for (var doc in snapshot.docs) {
      Message message = Message.fromFirestore(doc);

      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(message.userId).get();
      UserModel user = UserModel.fromFirestore(userSnapshot.data() as Map<String, dynamic>);

      messagesWithUserData.add({
        'message': message,
        'user': user,
      });
    }

    return messagesWithUserData;
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

Stream<List<Rooms?>> getAllRooms() async* {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Get all room documents
    QuerySnapshot roomSnapshots = await firestore.collection('rooms').get();
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

    yield rooms;
  } catch (e) {
    print('Error fetching rooms: $e');
    yield [];
  }
}



// Updated getRoomById function
Stream<Rooms?> getRoomById(String roomId) async* {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Get the room document
    DocumentSnapshot roomSnapshot = await firestore.collection('rooms').doc(roomId).get();

    if (roomSnapshot.exists) {
      Rooms room = Rooms.fromFirestore(roomSnapshot.data() as Map<String, dynamic>);

      // Get the members' data
      List<UserModel> membersData = [];
      for (var member in room.membersId) {
        DocumentSnapshot userSnapshot = await firestore.collection('users').doc(member.uid).get();
        if (userSnapshot.exists) {
          UserModel user = UserModel.fromFirestore(userSnapshot.data() as Map<String, dynamic>);

                    if (member.isAdmin != null && member.isAdmin == true) {
              user.isAdmin = true;
            } else {
              user.isAdmin = false;
            }

            membersData.add(user);
          }

      }

      // Include the members' data in the room object or handle it separately
      room.membersData = membersData;

      yield room;
    } else {
      yield null;
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

  Future<void> createRoom(String roomName, String roomId, String adminId,String avtarRoomUrl,
      {required String roomType}) async {
    await _db.collection('rooms').doc(roomId).set({
      'timestamp': FieldValue.serverTimestamp(),
      'membersId': [Member(uid: adminId, isAdmin: true).toMap()],
      'roomId': roomId,
      'roomName': roomName,
      'roomType': roomType,
      'videoId':'',
      'avtarRoomUrl':avtarRoomUrl,
    });
  }

  Future<void> joinRoom(String roomId, String userId) async {
      Member member = Member(uid: userId, isAdmin: false);

    await _db.collection('rooms').doc(roomId).update({
    'membersId': FieldValue.arrayUnion([member.toMap()]),
    });
  }
Future<void> leaveRoom(String roomId,  Member member) async {

  await _db.collection('rooms').doc(roomId).update({
    'membersId': FieldValue.arrayRemove([member.toMap()]),
  });
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

  Future<void> reactionMsg(Likes emoji, String userId, String docId, String roomId) async {
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
