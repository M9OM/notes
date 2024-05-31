import 'package:flutter/material.dart';
import 'package:notes/utils/constants/assets_constants.dart';

class SettingsModel {
  final String iconSvg;
  final String title;
  final String subtitle;
  final Color bgColor; // Background color for the icon

  SettingsModel({
    required this.iconSvg,
    required this.title,
    required this.subtitle,
    required this.bgColor,
  });

  static List<SettingsModel> SettingsList = [
    SettingsModel(
      iconSvg: AssetsConstants.upgradeSvg,
      title: 'ترقية الحساب',
      subtitle: 'قم بترقية حسابك و احصل على كثير من المزايا',
      bgColor: Colors.blue, // Example background color
    ),
    SettingsModel(
      iconSvg: AssetsConstants.friendsSvg,
      title: 'الاصدقاء',
      subtitle: 'تعرف على الاصدقاء الذين قابلتهم',
      bgColor: Colors.green, // Example background color
    ),
    SettingsModel(
      iconSvg: AssetsConstants.notificationSvg,
      title: 'الاشعارات',
      subtitle: 'تشغيل او اطفاء',
      bgColor: Colors.orange, // Example background color
    ),
  ];
}
