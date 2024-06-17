import 'package:flutter/material.dart';
import 'package:notes/utils/constants/color.dart';

class AvatarWidget extends StatelessWidget {
  AvatarWidget({super.key, required this.radius, required this.photoURL});
  final int radius;
  final String photoURL;
  @override
  Widget build(BuildContext context) {
    return photoURL == 'add_pic'
        ? CircleAvatar(
          backgroundColor: GetThemeData(context).theme.highlightColor,
            radius: radius.toDouble(),
            child: Icon(
              Icons.add,
              color: primary,
              size: 100,
            ),
          )
        : CircleAvatar(
            radius: radius.toDouble(),
            backgroundImage: photoURL.contains('http')
                ? NetworkImage(photoURL)
                : AssetImage('assets/avatar/$photoURL.jpeg')
                    as ImageProvider<Object>?,
          );
  }
}
