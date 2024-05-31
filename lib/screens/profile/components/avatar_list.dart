import 'package:flutter/material.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';

import '../../../controllers/profile_controller.dart';

class AvatarList extends StatelessWidget {
  const AvatarList({Key? key});

  @override
  Widget build(BuildContext context) {
    // List of avatar image paths
    List<String> pathAvatar = [
      'assets/avatar/0.jpeg',
      'assets/avatar/1.jpeg', // Add more paths here as needed
    ];

    return Container(
      height: ScreenSizeExtension(context).screenHeight * 0.7,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two avatars per row
            crossAxisSpacing: 10.0, // Spacing between avatars horizontally
            mainAxisSpacing: 10.0, // Spacing between avatars vertically
          ),
          itemCount: 24,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Provider.of<ProfileController>(context, listen: false)
                    .setImageAvatar(index.toString());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar/$index.jpeg'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
