import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? uid;
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
    this.interest,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      uid: json['uid'],
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
    data['photoURL'] = photoURL;
    data['lastOnline'] = lastOnline;
    data['createdAt'] = createdAt;
    data['interest'] = interest;

    return data;
  }
}
