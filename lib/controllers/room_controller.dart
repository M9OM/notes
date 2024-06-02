import 'package:flutter/material.dart';
import 'package:notes/utils/enum/RoomType.dart';

RoomType? selectedRoomType;

String getTypeName(RoomType type) {
  switch (type) {
    case RoomType.public:
      return 'عامة';
    case RoomType.games:
      return 'العاب';
    case RoomType.politics:
      return 'سياسة';
    case RoomType.history:
      return 'تاريخ';
    case RoomType.programming:
      return 'برمجة';
    case RoomType.cooking:
      return 'طبخ';
    case RoomType.travel:
      return 'السفر';
    case RoomType.reading:
      return 'القراءة';
    case RoomType.science:
      return 'العلوم';
  }
}

class RoomController with ChangeNotifier {
  String pathImageRoomAvatar = '';

  void setImageRoomAvatar(String imageAvatar) {
    this.pathImageRoomAvatar = imageAvatar;
    notifyListeners();
  }
}
