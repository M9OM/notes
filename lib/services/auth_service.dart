import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        photoURL: '',
        createdAt: Timestamp.now(),
        lastOnline: Timestamp.now(),
        interest: [],
      );
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
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
