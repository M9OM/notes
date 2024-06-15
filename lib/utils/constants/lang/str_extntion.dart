import 'package:flutter/material.dart';
import 'package:notes/app_localizations.dart';
extension StringExtension on String {
  String t(BuildContext context) {
    return AppLocalizations.of(context)!.translate(this) ?? '';
  }
}
