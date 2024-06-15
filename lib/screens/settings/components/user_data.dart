import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/controllers/user_stream_controller.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/screens/settings/components/avatar_list.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';

import '../../../controllers/profile_controller.dart';

class UserData extends StatelessWidget {
  const UserData({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Center(
      child: UserStreamBuilder(
        uid: user!.uid,
        loading: CircleAvatar(
          radius: 60,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Text('Error loading user data');
          } else {
            UserModel userData = snapshot.data!;


              String username = userData.username ?? '';
              if (username.length > 35) {
                username = username.substring(0, 35)+' ...';
              }
          String email = userData.email ?? '';
              if (email.length > 35) {
                email = email.substring(0, 35)+' ...';
              }
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Consumer<ProfileController>(
                  builder: (context, avatarController, _) {
                    return Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(avatarController
                                  .pathImageAvatar.isEmpty
                              ? 'assets/avatar/${userData.photoURL}.jpeg'
                              : 'assets/avatar/${avatarController.pathImageAvatar}.jpeg'),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return const AvatarList();
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                border: Border.all(width: 3),
                                color: primary,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  username!,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  email!,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
