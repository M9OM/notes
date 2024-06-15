import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? uid;
  bool? isAdmin;
  String? photoURL;
  Timestamp? lastOnline;
  Timestamp? createdAt;
  List<dynamic>? interest;
  String? playerId;
  List<String>? followers; // List of follower user IDs
  List<String>? following; // List of user IDs being followed
  List<String>? blockedUsers; // List of user IDs that the user has blocked

  UserModel({
    this.username,
    this.email,
    this.uid,
    this.isAdmin,
    this.photoURL,
    this.lastOnline,
    this.createdAt,
    this.interest,
    this.playerId,
    this.followers,
    this.following,
    this.blockedUsers,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      uid: json['uid'],
      isAdmin: json['isAdmin'],
      photoURL: json['photoURL'],
      lastOnline: json['lastOnline'],
      createdAt: json['createdAt'],
      interest: json['interest'],
      playerId: json['playerId'],
      followers: json['followers'] != null ? List<String>.from(json['followers']) : null,
      following: json['following'] != null ? List<String>.from(json['following']) : null,
      blockedUsers: json['blockedUsers'] != null ? List<String>.from(json['blockedUsers']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['uid'] = uid;
    data['isAdmin'] = isAdmin;
    data['photoURL'] = photoURL;
    data['lastOnline'] = lastOnline;
    data['createdAt'] = createdAt;
    data['interest'] = interest;
    data['playerId'] = playerId;
    data['followers'] = followers;
    data['following'] = following;
    data['blockedUsers'] = blockedUsers;

    return data;
  }
}
