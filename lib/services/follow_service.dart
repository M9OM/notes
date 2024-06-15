import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/notification_service.dart';

import '../models/user_model.dart';

class FollowService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String targetUserId, String playerId) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String currentUserId = currentUser.uid;

      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayUnion([targetUserId])
      });

      await _firestore.collection('users').doc(targetUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });
      final currentUserData = await AuthService().getCurrentUserData();

      NotificationsService().sendNotification(
          [playerId], '${currentUserData!.username} قام بمتابعتك' , currentUserData!.username.toString());
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String currentUserId = currentUser.uid;

      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayRemove([targetUserId])
      });

      await _firestore.collection('users').doc(targetUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });
    }
  }

  Stream<List<String>> getFollowing(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return List<String>.from(snapshot.data()?['following'] ?? []);
    });
  }

  Stream<List<String>> getFollowers(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return List<String>.from(snapshot.data()?['followers'] ?? []);
    });
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('users').doc(userId).get();
    return docSnapshot.data() as Map<String, dynamic>?;
  }

  Future<List<UserModel>> getFollowersData(String userId) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('users').doc(userId).get();
    List<String> followers = List<String>.from(docSnapshot['followers'] ?? []);
    List<UserModel> followersData = [];

    for (String followerId in followers) {
      DocumentSnapshot followerSnapshot =
          await _firestore.collection('users').doc(followerId).get();
      if (followerSnapshot.exists) {
        followersData.add(UserModel.fromFirestore(
            followerSnapshot.data() as Map<String, dynamic>));
      }
    }

    return followersData;
  }




  Future<List<UserModel>> getFollowingData(String userId) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('users').doc(userId).get();
    List<String> following = List<String>.from(docSnapshot['following'] ?? []);
    List<UserModel> followingData = [];

    for (String followingId in following) {
      DocumentSnapshot followingSnapshot =
          await _firestore.collection('users').doc(followingId).get();
      if (followingSnapshot.exists) {
        followingData.add(UserModel.fromFirestore(
            followingSnapshot.data() as Map<String, dynamic>));
      }
    }

    return followingData;
  }
    Stream<bool> isFollowing(String currentUserId, String targetUserId) {
    return _firestore.collection('users').doc(currentUserId).snapshots().map((snapshot) {
      final followingList = List<String>.from(snapshot.data()?['following'] ?? []);
      return followingList.contains(targetUserId);
    });
    }
}
