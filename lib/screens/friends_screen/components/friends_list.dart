import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/services/follow_service.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';

class FollowersWidget extends StatelessWidget {
  final String userId;

  FollowersWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
        final user = Provider.of<User?>(context);

    return FutureBuilder<List<UserModel>>(
      future: FollowService().getFollowersData(userId),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<UserModel> followers = snapshot.data!;
          if (followers.isEmpty) {
            return const Center(child: Text('No followers found'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  3, // Adjust this value to change the number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: followers.length,
            itemBuilder: (context, index) {
              UserModel follower = followers[index];
              String username = follower.username!.length < 10
                  ? follower.username!
                  : '${follower.username!.substring(0, 10)}...';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/avatar/${follower.photoURL!}.jpeg'),
                        radius: 40.0,
                      ),
                      Positioned(
                          top: 50,
                          right: -10,
                          child:StreamBuilder<bool>(
                  stream: FollowService().isFollowing(user!.uid, follower.uid.toString()),
                  initialData: false,
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? IconButton(onPressed:() async {
                              await FollowService().unfollowUser(
                                  follower.uid.toString());

                            }, icon: Icon(Icons.person_remove, color: primary,))
                        : IconButton(
                            onPressed: () async {
                              await FollowService().followUser(
                                  follower.uid.toString(), follower.playerId.toString());

                            },
                            icon: Icon(Icons.person_add,color: primary),
                          );
                  },
                ))
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
