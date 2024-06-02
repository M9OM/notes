import 'package:flutter/material.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/screens/home/home_screen.dart';
import 'package:notes/screens/main_screen/components/bottomBarWidget.dart';

import '../../utils/constants/assets_constants.dart';
import 'components/BottomNaviation.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    RoomScreen(
      roomId: 'mohammed-NfK576',
    ),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:Drawer(),
      body: IndexedStack(
        children: pages,
        index: _selectedIndex,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavigationBar() => BottomNaviation(
        items: [
          BottomNavWidget(
            svgIcon: AssetsConstants.houseSvg,
            isSelected: _selectedIndex == 0,
            onTap: () {
              onItemTapped(0);
            },
          ),
          BottomNavWidget(
            svgIcon: AssetsConstants.personSvg,
            isSelected: _selectedIndex == 1,
            onTap: () {
              onItemTapped(1);
            },
          ),
          BottomNavWidget(
            svgIcon: AssetsConstants.cartSvg,
            isSelected: _selectedIndex == 2,
            onTap: () {
              onItemTapped(2);
            },
          ),
        ],
      );
}
