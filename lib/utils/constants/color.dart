import 'package:flutter/material.dart';
EdgeInsetsGeometry padding = const EdgeInsets.all(15);
AlignmentGeometry meAlignment = Alignment.topRight;
AlignmentGeometry aiAlignment = Alignment.topLeft;
BorderRadiusGeometry borderRadiusOther = const BorderRadius.all(
  Radius.circular(20),
);
BorderRadiusGeometry borderRadiusMe = const BorderRadius.all(
  Radius.circular(20),
);

TextStyle  myMsgStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.black, fontSize: 15);
TextStyle  yourMsgStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15);


Color primary =const Color(0xFFCBFF97);

Color inputBgColor = Color.fromARGB(255, 46, 46, 46);
const Map<int, Color> colorMap = {
  50: Color.fromRGBO(203, 255, 151, .1),
  100: Color.fromRGBO(203, 255, 151, .2),
  200: Color.fromRGBO(203, 255, 151, .3),
  300: Color.fromRGBO(203, 255, 151, .4),
  400: Color.fromRGBO(203, 255, 151, .5),
  500: Color.fromRGBO(203, 255, 151, .6),
  600: Color.fromRGBO(203, 255, 151, .7),
  700: Color.fromRGBO(203, 255, 151, .8),
  800: Color.fromRGBO(203, 255, 151, .9),
  900: Color.fromRGBO(203, 255, 151, 1),
};

// Create a MaterialColor
const MaterialColor customSwatch = MaterialColor(0xFFCBFF97, colorMap);

extension GetThemeData on BuildContext {
  ThemeData get theme => Theme.of(this);
}
