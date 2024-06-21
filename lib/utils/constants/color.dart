import 'package:flutter/material.dart';
EdgeInsetsGeometry padding = const EdgeInsets.all(15);
AlignmentGeometry meAlignment = Alignment.topRight;
AlignmentGeometry aiAlignment = Alignment.topLeft;
BorderRadiusGeometry borderRadiusOther = const BorderRadius.all(
  Radius.circular(50),
);
BorderRadiusGeometry borderRadiusMe = const BorderRadius.all(
  Radius.circular(50),
);
TextStyle  yourNameMsgStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15);

TextStyle  myMsgStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.black, fontSize: 17);
TextStyle  yourMsgStyle = const TextStyle(fontWeight: FontWeight.w200,color: Colors.white,fontSize: 14);
TextStyle  myMsgtimeStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.black, fontSize: 12,
);
TextStyle  yourMsgtimeStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 12,
);




                

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
final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primary, width: 1.0),
    borderRadius: BorderRadius.circular(8.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.circular(8.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: const Color.fromARGB(255, 134, 113, 111), width: 1.0),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.circular(8.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

// Create a MaterialColor
const MaterialColor customSwatch = MaterialColor(0xFFCBFF97, colorMap);

extension GetThemeData on BuildContext {
  ThemeData get theme => Theme.of(this);
}
