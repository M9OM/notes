import 'package:flutter/material.dart';
import 'package:notes/ui/background.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';

import '../../../controllers/lang_controller.dart';

class ChangeLangScreen extends StatelessWidget {
  const ChangeLangScreen({super.key});

  @override
  Widget build(BuildContext context) {
var lang_controller = Provider.of<LanguageController>(context, listen: false);


         

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(TranslationConstants.arabic.t(context)),
            leading: InkWell(
              onTap: () {
            lang_controller.setLanguage(
              'ar');
              },
              child: CircleAvatar(
                                radius: 15,

                backgroundColor: primary,
                child:lang_controller.currentLanguage == 'ar'? Icon(Icons.check, color: Colors.black,):SizedBox.shrink(),)
            ),
          ),
          ListTile(
            title: Text(TranslationConstants.english.t(context)),
            leading: InkWell(
              onTap: () {
                            lang_controller.setLanguage(
              'en');

              },
              child: CircleAvatar(
                                radius: 15,
                backgroundColor: primary,
                child:lang_controller.currentLanguage == 'en'? Icon(Icons.check,
                color: Colors.black):SizedBox.shrink(),)
            ),
          ),
        ],
      ),
    );
  }
}
