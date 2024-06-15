import 'package:flutter/foundation.dart';

class RoomPresenceProvider with ChangeNotifier {
  bool _isInRoom = false;

  bool get isInRoom => _isInRoom;

  void enterRoom() {
    _isInRoom = true;
    notifyListeners();
  }

  void leaveRoom() {
    _isInRoom = false;
    notifyListeners();
  }
}
