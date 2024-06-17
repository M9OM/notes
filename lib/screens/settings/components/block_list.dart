import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/services/blockservice.dart';
import 'package:notes/services/follow_service.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';

class BlockList extends StatelessWidget {
  final String userId;

  BlockList({required this.userId});

  @override
  Widget build(BuildContext context) {
        final user = Provider.of<User?>(context);

    return FutureBuilder<List<UserModel>>(
      future: BlockService().getblockData(userId),
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<UserModel> blocks = snapshot.data!;
          if (blocks.isEmpty) {
            return const Center(child: Text(''));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  3, // Adjust this value to change the number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              UserModel block = blocks[index];
              String username = block.username!.length < 10
                  ? block.username!
                  : '${block.username!.substring(0, 10)}...';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                                              AvatarWidget(radius:40, photoURL:block.photoURL.toString()),


                      Positioned(
                          top: 40,
                          right: -10,
                          child:StreamBuilder<bool>(
                  stream: BlockService().isBlocked(user!.uid, block.uid.toString()),
                  initialData: false,
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? IconButton(onPressed:() async {
                              await BlockService().unblockUser(user!.uid,
                                  block.uid.toString());

                            }, icon: Icon(Icons.block, color: Colors.red.withOpacity(0.5),size: 30,))
                        : IconButton(
                            onPressed: () async {
                              await BlockService().blockUser(
                                  block.uid.toString(), block.playerId.toString());

                            },
                            icon: Icon(Icons.block,color: Colors.red.withOpacity(0.9)),
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
