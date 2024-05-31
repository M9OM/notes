import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../ui/background.dart';
import 'components/settings_list.dart';
import 'components/user_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        shadowColor: Colors.transparent,
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
            color:
                Colors.white), // Set the icon color to white or any other color
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
              color: Colors
                  .white), // Set the text color to white or any other color
        ),
      ),
      body: Mybackground(
        screens: const [
          SizedBox(
            height: 50,
          ),
          UserData(),
          SizedBox(
            height: 20,
          ),
          Expanded(child: SettingsList()),
        ],
      ),
    );
  }
}
