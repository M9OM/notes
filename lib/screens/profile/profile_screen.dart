import 'package:flutter/material.dart';

import '../../ui/background.dart';
import 'components/user_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        screens: [UserData()],
      ),
    );
  }
}
