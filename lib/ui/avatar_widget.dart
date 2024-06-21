import 'package:flutter/material.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  AvatarWidget({Key? key, required this.radius, required this.photoURL}) : super(key: key);
  
  final double radius; // Use double for radius to align with CircleAvatar's requirements
  final String photoURL;
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: photoURL == 'add_pic' ? Theme.of(context).highlightColor : null,
      child: photoURL == 'add_pic'
          ? Icon(
              Icons.add,
              color: primary,
              size: radius,
            )
          : ClipOval(
              child: photoURL.contains('http')
                  ? CachedNetworkImage(
                      imageUrl: photoURL,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/avatar/$photoURL.jpeg',
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }
}
