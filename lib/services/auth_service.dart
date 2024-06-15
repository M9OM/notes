import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/services/send_email_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<UserModel?> getUserDataStreamByUid(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromFirestore(snapshot.data()!);
      } else {
        return null;
      }
    });
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<UserModel?> getCurrentUserData() async {
    final currentUser = await _auth.currentUser;
    if (currentUser != null) {
      final userDataSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDataSnapshot.exists) {
        return UserModel.fromFirestore(
            userDataSnapshot.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<UserModel?> getDataUser(String uid) async {
    final currentUser = await _auth.currentUser;
    if (currentUser != null) {
      final userDataSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (userDataSnapshot.exists) {
        return UserModel.fromFirestore(
            userDataSnapshot.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      UserModel newUser = UserModel(
          uid: user!.uid,
          email: email,
          username: username,
          photoURL: '26',
          createdAt: Timestamp.now(),
          lastOnline: Timestamp.now(),
          interest: [],
          followers: [],
          playerId: OneSignal.User.pushSubscription.id,
          following: []);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUser.toFirestore());
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateImageUrl(String uid, String pathImage) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoURL': pathImage,
      });
    } catch (e) {
      print("Error updating image URL: $e");
    }
  }

  Future<void> removePlayerId(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'playerId': '',
      });
    } catch (e) {
      print("Error updating image URL: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      removePlayerId(_auth.currentUser!.uid);
    } catch (e) {
      print(e.toString());
    }
  }
}
