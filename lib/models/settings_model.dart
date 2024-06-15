import 'package:flutter/material.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/friends_screen/friends_screen.dart';
import 'package:notes/screens/settings/block_screen.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';

import '../controllers/lang_controller.dart';
import '../screens/settings/lang/change_lang_screen.dart';
import '../utils/constants/dilog.dart';

class SettingsModel {
  final String iconSvg;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Function(BuildContext)? onTap;

  SettingsModel({
    required this.iconSvg,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    this.onTap,
  });

  static List<SettingsModel> getSettingsList(BuildContext context) {
    return [
      // SettingsModel(
      //   iconSvg: AssetsConstants.upgradeSvg,
      //   title: 'ترقية الحساب',
      //   subtitle: 'قم بترقية حسابك و احصل على كثير من المزايا',
      //   bgColor: Colors.blue, // Example background color
      // ),

      SettingsModel(
        iconSvg: AssetsConstants.friendsSvg,
        title: TranslationConstants.friends.t(context),
        subtitle: TranslationConstants.meet_friends.t(context),
        bgColor: Colors.green,
        onTap: (ctx) {
          navigateToCreateRoomScreen(
              ctx, FriendsScreen()); // Make sure `screen` is defined
        },
      ),
      // SettingsModel(
      //   iconSvg: AssetsConstants.notificationSvg,
      //   title: TranslationConstants.notifications.t(context),
      //   subtitle: TranslationConstants.enable_disable.t(context),
      //   bgColor: Colors.orange, // Example background color
      // ),

      SettingsModel(
        iconSvg: AssetsConstants.lagSvg,
        title: TranslationConstants.languages.t(context),
        subtitle:
            '${TranslationConstants.english.t(context)}/${TranslationConstants.arabic.t(context)}',
        bgColor: Colors.blue,
        onTap: (ctx) {
          navigateToCreateRoomScreen(context, ChangeLangScreen());

          // Provider.of<LanguageController>(context, listen: false).setLanguage(
          //     Provider.of<LanguageController>(context,listen: false).currentLanguage == 'en'
          //         ? 'ar'
          //         : 'en');
        },

        // Example background color
      ),
       SettingsModel(
        iconSvg: AssetsConstants.blockSvg,
        title: TranslationConstants.block.t(context),
        subtitle: TranslationConstants.block_subtitle.t(context),
        bgColor: Colors.purple,
        onTap: (ctx) {
          navigateToCreateRoomScreen(context, BlockScreen());

        },

        // Example background color
      ),
      SettingsModel(
        iconSvg: AssetsConstants.heartCrackSvg,
        title: TranslationConstants.deactivate_account.t(context),
        subtitle: TranslationConstants.account_irreversible.t(context),
        bgColor: Colors.red,
        onTap: (ctx) {
          showMsgDialog(
              context: context,
              title: TranslationConstants.confirm_deactivation.t(context),
              onTap: () {
                AuthService().signOut();
                Navigator.pop(ctx);
              });
        },

        // Example background color
      ),
    ];
  }
}
