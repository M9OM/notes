import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/screens/settings/settings_screen.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/ui/background.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';

import '../../../controllers/chat_controller.dart';
import '../../../controllers/user_stream_controller.dart';
import '../../../utils/constants/dilog.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Drawer(
      child: Mybackground(screens: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserStreamBuilder(
                  uid: user!.uid,
                  builder: (context, snapshot) {
                    UserModel userData = snapshot.data!;

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return const ListTile(
                        title: Text('Error loading user data'),
                      );
                    } else {
                      UserModel userData = snapshot.data!; // Updated this line

                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                      'assets/avatar/${userData.photoURL!}.jpeg'),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  loading: const SizedBox(
                    height: 170,
                  )),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.houseSvg,
                  color: Colors.white,
                ),
                title: const Text('الرئيسة'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Home action
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.friendsSvg,
                  color: Colors.white,
                ),
                title: const Text('الاصدقاء'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle the Settings action
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.settingsSvg,
                  color: Colors.white,
                ),
                title: const Text('الاعدادات'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.logOutSvg,
                  color: Colors.white,
                ),
                title: const Text('تسجيل خروج'),
                onTap: () {
                  showMsgDialog(
                      context: context,
                      title: 'هل انت متأكد من انك تود تسجيل خروجك؟',
                      onTap: () {
                        AuthService().signOut();
                      });

                  // Handle the Logout action
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
