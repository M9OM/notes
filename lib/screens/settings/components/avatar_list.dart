import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/settings/components/gif_picker_avatar.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/upload_scrvice.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';

import '../../../controllers/profile_controller.dart';

class AvatarList extends StatefulWidget {
  const AvatarList({Key? key});

  @override
  State<AvatarList> createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  String? imageUrl;

  void _uploadImage() async {
    final user = await AuthService().getCurrentUser();
    UploadService uploadService = UploadService();
    // ignore: use_build_context_synchronously
    String? url = await uploadService.pickAndUploadImage(context);
    await AuthService().updateImageUrl(user!.uid, url!);

  }

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
              onTap: () async {
                if (index == 0) {
                  _uploadImage();
Navigator.pop(context);
                } else {
    await AuthService().updateImageUrl(user!.uid, index.toString());



                }
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvatarWidget(
                      radius: 90,
                      photoURL: index == 0 ? 'add_pic' : index.toString())),
            );
          },
        ),
      ),
    );
  }
}
