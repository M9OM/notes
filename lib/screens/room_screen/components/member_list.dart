import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/services/follow_service.dart';
import 'package:provider/provider.dart';

import '../../../services/blockservice.dart';

class MembersList extends StatefulWidget {
  final List<UserModel?> membersData;
  final bool isAdmin;

  MembersList({Key? key, required this.membersData, required this.isAdmin})
      : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  late User? currentUser;
  late List<bool> followStatus;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<User?>(context, listen: false);
    followStatus = List.generate(widget.membersData.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.membersData.length,
      itemBuilder: (context, index) {
        UserModel? member = widget.membersData[index];
        String username = member?.username ?? 'No name';
        // Show only the first 15 letters of the username
        if (username.length > 15) {
          username = username.substring(0, 15) + ' ...';
        }

        return ListTile(
          trailing: currentUser != null && currentUser!.uid != member!.uid
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // متابعة / إلغاء متابعة
                    StreamBuilder<bool>(
                      stream: FollowService()
                          .isFollowing(currentUser!.uid, member.uid.toString()),
                      initialData: false,
                      builder: (context, snapshot) {
                        return snapshot.data == true
                            ? IconButton(
                                onPressed: () async {
                                  await FollowService()
                                      .unfollowUser(member.uid.toString());
                                  setState(() {
                                    followStatus[index] = false;
                                  });
                                },
                                icon: Icon(Icons.person_remove),
                              )
                            : IconButton(
                                onPressed: () async {
                                  await FollowService().followUser(
                                      member.uid.toString(),
                                      member.playerId.toString());
                                  setState(() {
                                    followStatus[index] = true;
                                  });
                                },
                                icon: Icon(Icons.person_add),
                              );
                      },
                    ),
                    // زر الحظر
                    StreamBuilder<bool>(
                      stream: BlockService()
                          .isBlocked(currentUser!.uid, member.uid.toString()),
                      initialData: false,
                      builder: (context, snapshot) {
                        return snapshot.data == true
                            ? IconButton(
                                onPressed: () async {
                                  await BlockService().unblockUser(
                                      currentUser!.uid, member.uid.toString());
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    content: Text(
                                        '${member.username} has been unblocked.',
                                        style: TextStyle(color: Colors.white)),
                                  ));

                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.block,
                                    color: Colors.red.withOpacity(0.5)),
                              )
                            : IconButton(
                                onPressed: () async {
                                  await BlockService().blockUser(
                                      currentUser!.uid, member.uid.toString());
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    content: Text(
                                      '${member.username} has been blocked.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));

                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.block, color: Colors.red),
                              );
                      },
                    ),
                  ],
                )
              : null, // If user is null or user's UID matches member's UID, hide the buttons
          leading: CircleAvatar(
            backgroundImage:
                member!.photoURL != null && member.photoURL!.isNotEmpty

                    //assets/avatar
                    ? AssetImage('assets/avatar/${member.photoURL!}.jpeg')
                    : AssetImage('assets/avatar/${member.photoURL!}.jpeg')
                        as ImageProvider,
          ),
          title: Text(
            username,
            style: TextStyle(fontSize: 15),
          ),
          // subtitle: Text(widget.isAdmin ? TranslationConstants.admin.t(context) : ''),
        );
      },
    );
  }
}
