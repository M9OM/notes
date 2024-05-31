import 'package:flutter/material.dart';

class LoadingController with ChangeNotifier {
  bool _isloading = false;
  bool get isloading => _isloading;

  void loading(bool loading) async {
    _isloading = loading;
    notifyListeners();
  }
}
