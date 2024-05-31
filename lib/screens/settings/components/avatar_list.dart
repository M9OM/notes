import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/auth_service.dart';
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
              onTap: () async{


                await AuthService().updateImageUrl(user!.uid, index.toString());

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
