import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/controllers/room_controller.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';

import '../../../controllers/profile_controller.dart';

class AvatarRoomList extends StatelessWidget {
  const AvatarRoomList({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      height: ScreenSizeExtension(context).screenHeight * 0.7,
      color: const Color.fromARGB(255, 35, 35, 35).withOpacity(0.5),
      child: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two avatars per row
            crossAxisSpacing: 10.0, // Spacing between avatars horizontally
            mainAxisSpacing: 10.0, // Spacing between avatars vertically
          ),
          itemCount: 24,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                Provider.of<RoomController>(context, listen: false)
                    .setImageRoomAvatar(index.toString());
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/avatar/$index.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
