import 'package:flutter/material.dart';

class ProfileController with ChangeNotifier {
  String pathImageAvatar = '';

  void setImageAvatar(String imageAvatar) {
    this.pathImageAvatar = imageAvatar;
    notifyListeners();
  }
}
