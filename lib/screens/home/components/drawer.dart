import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/screens/settings/settings_screen.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/ui/background.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/user_stream_controller.dart';
import '../../../route/route_screen.dart';
import '../../../utils/constants/dilog.dart';
import '../../../utils/constants/lang/translate_constat.dart';
import '../../friends_screen/friends_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});
  Future<void> _launchUrl(String _url) async {
    final Uri url = Uri.parse(_url);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Drawer(
      child:
          Mybackground(mainAxisAlignment: MainAxisAlignment.center, screens: [
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
                                AvatarWidget(radius: 35, photoURL: userData.photoURL!)
,
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
                title: Text(TranslationConstants.home.t(context)),
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
                title: Text(TranslationConstants.friends.t(context)),
                onTap: () {
                  navigateToCreateRoomScreen(context,
                      FriendsScreen()); // Make sure `screen` is defined
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.settingsSvg,
                  color: Colors.white,
                ),
                title: Text(TranslationConstants.setting.t(context)),
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
                    AssetsConstants.instaSvg,
                    color: Colors.white,
                  ),
                  title: Text(
                      TranslationConstants.account_of_developer.t(context)),
                  onTap: () {
                    _launchUrl(
                        'https://www.instagram.com/uxxixzzq?igsh=emhva25vZWRxeG5m&utm_source=qr');
                  }),
              ListTile(
                  leading: SvgPicture.asset(
                    'assets/icon/info.svg',
                    color: Colors.white,
                  ),
                  title: Text(TranslationConstants.privcy_policy.t(context)),
                  onTap: () {
                    _launchUrl(
                        'https://docs.google.com/document/d/e/2PACX-1vSTUxTjlvlSp5w-pf6ZvVuYw5ieHloRSTt0JHjE73nmxXWHOULngB0CFXe6wXIKieye0O0ZBaxJmfBB/pub');
                  }),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsConstants.logOutSvg,
                  color: Colors.white,
                ),
                title: Text(TranslationConstants.logout.t(context)),
                onTap: () {
                  showMsgDialog(
                      context: context,
                      title: TranslationConstants.do_u_sure_u_want_logout
                          .t(context),
                      onTap: () {
                        AuthService().signOut();
                        Navigator.pop(context);
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
