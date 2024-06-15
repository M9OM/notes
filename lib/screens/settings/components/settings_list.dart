import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/settings_model.dart';



class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate(SettingsModel.getSettingsList(context).length, (index) {
        final setting = SettingsModel.getSettingsList(context)[index];
        return ListTile(
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
          leading: Container(
            decoration: BoxDecoration(
              color: setting.bgColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(8), // Adjust padding as needed
            child: SvgPicture.asset(setting.iconSvg, color: setting.bgColor),
          ),
          title: Text(setting.title),
          subtitle: Text(setting.subtitle),
          onTap: () {
            setting.onTap!(context);
          },
        );
      }),
    );
  }
}
