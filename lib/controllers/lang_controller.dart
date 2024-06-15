import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController with ChangeNotifier {
  String _currentLanguage = 'en'; // Default language

  String get currentLanguage => _currentLanguage;

  Future<void> setLanguage(String newLanguage) async {
    _currentLanguage = newLanguage;
    notifyListeners();
    // Save the selected language to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newLanguage);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('lang') ?? 'en'; // Default to English if no language is stored
    notifyListeners();
  }

  // Method to get the current language code from SharedPreferences
  Future<String> getCurrentLanguageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang') ?? 'en'; // Default to English if no language is stored
  }
}
