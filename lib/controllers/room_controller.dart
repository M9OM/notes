import 'package:flutter/material.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:notes/utils/enum/RoomType.dart';

RoomType? selectedRoomType;

String getTypeName(RoomType type , BuildContext context) {
  switch (type) {
    case RoomType.public:
      return TranslationConstants.general.t(context);
    case RoomType.games:
      return TranslationConstants.general.t(context);
    case RoomType.politics:
      return TranslationConstants.politics.t(context);
    case RoomType.history:
      return TranslationConstants.history.t(context);
    case RoomType.programming:
      return TranslationConstants.programing.t(context);
    case RoomType.cooking:
      return TranslationConstants.cooking.t(context);
    case RoomType.travel:
      return TranslationConstants.travel.t(context);
    case RoomType.reading:
      return TranslationConstants.reading.t(context);
    case RoomType.science:
      return TranslationConstants.science.t(context);
  }
}

class RoomController with ChangeNotifier {
  String pathImageRoomAvatar = '';

  void setImageRoomAvatar(String imageAvatar) {
    this.pathImageRoomAvatar = imageAvatar;
    notifyListeners();
  }
}
