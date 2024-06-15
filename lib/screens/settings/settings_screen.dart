import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/screens/auth/login_screen.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';

import '../../ui/background.dart';
import 'components/settings_list.dart';
import 'components/user_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

        final user = Provider.of<User?>(context);
    if (user == null) {
      // ttإذا كان المستخدم null، يمكنك إعادة توجيهه إلى شاشة تسجيل الدخول أو إظهار رسالة خطأ
      return const LoginScreen();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        shadowColor: Colors.transparent,
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
            color:
                Colors.white), // Set the icon color to white or any other color
        title:  Text(
TranslationConstants.profile.t(context),


          style: TextStyle(
              color: Colors
                  .white), // Set the text color to white or any other color
        ),
      ),
      body: Mybackground(
                    mainAxisAlignment  : MainAxisAlignment.center,

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
