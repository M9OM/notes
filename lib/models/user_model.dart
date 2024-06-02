import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? uid;
  bool? isAdmin; // Updated to bool
  String? photoURL;
  Timestamp? lastOnline;
  Timestamp? createdAt;
  List<dynamic>? interest;

  UserModel({
    this.username,
    this.email,
    this.uid,
    this.photoURL,
    this.lastOnline,
    this.createdAt,
    this.isAdmin,
    this.interest,
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

    return data;
  }
}
