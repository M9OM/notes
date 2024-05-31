import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Message>> getMessages() {
    return _db
        .collection('room/messages')
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

  Future<void> createRoom(
      String roomName, String roomId, String adminId) async {
    await _db.collection('rooms').doc(roomId).set({
      'timestamp': FieldValue.serverTimestamp(),
      'membersId': [adminId],
      'roomId': roomId,
      'roomName': roomName,
    });
  }

  Future<void> joinRoom(String roomId, String userId) async {
    await _db.collection('rooms').doc(roomId).update({
      'membersId': FieldValue.arrayUnion([userId]),
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

  Future<void> reactionMsg(Likes emoji, String userId, String docId) async {
    try {
      await _db.collection('messages').doc(docId).update({
        'likes': FieldValue.arrayUnion([emoji.toFirestore()]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeReactionMsg(
      Likes emoji, String userId, String docId) async {
    try {
      await _db.collection('messages').doc(docId).update({
        'likes': FieldValue.arrayRemove([emoji.toFirestore()]),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
