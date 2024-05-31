import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/screens/main_screen/components/bottomBarWidget.dart';
import 'package:provider/provider.dart';

import '../../../controllers/page_controller.dart';

int _selectedIndex = 0;

class BottomNaviation extends StatelessWidget {
  const BottomNaviation({
    super.key,
    required this.items,
  });
  final List<BottomNavWidget> items;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 56,
          child: Consumer<PageControllerModel>(
              builder: (context, pageModel, child) {
            // int selected = pageModel.currentPageIndex;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            );
          }),
        ));
  }
}
