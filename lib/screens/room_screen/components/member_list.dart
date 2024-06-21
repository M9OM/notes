import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/services/follow_service.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';

import '../../../services/blockservice.dart';

class MembersList extends StatefulWidget {
  final List<UserModel?> membersData;

  MembersList({Key? key, required this.membersData}) : super(key: key);

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
        if (username.length > 9) {
          username = username.substring(0, 9) + '..';
        }

        return ListTile(
          subtitle: Text(widget.membersData[0] == widget.membersData[index]
              ? TranslationConstants.admin.t(context)
              : ''),

          trailing: currentUser != null && currentUser!.uid != member!.uid
              ? StreamBuilder<bool>(
                  stream: FollowService()
                      .isFollowing(currentUser!.uid, member.uid.toString()),
                  initialData: false,
                  builder: (context, followSnapshot) {
                    return StreamBuilder<bool>(
                      stream: BlockService()
                          .isBlocked(currentUser!.uid, member.uid.toString()),
                      initialData: false,
                      builder: (context, blockSnapshot) {
                        bool isFollowing = followSnapshot.data ?? false;
                        bool isBlocked = blockSnapshot.data ?? false;

                        return PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert),
                          onSelected: (String value) async {
                            if (value == 'follow' && !isFollowing) {
                              await FollowService().followUser(
                                  member.uid.toString(),
                                  member.playerId.toString());
                              setState(() {
                                followStatus[index] = true;
                              });
                            } else if (value == 'unfollow' && isFollowing) {
                              await FollowService()
                                  .unfollowUser(member.uid.toString());
                              setState(() {
                                followStatus[index] = false;
                              });
                            } else if (value == 'block' && !isBlocked) {
                              await BlockService().blockUser(
                                  currentUser!.uid, member.uid.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.black.withOpacity(0.8),
                                content: Text(
                                  '${member.username} has been blocked.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                            } else if (value == 'unblock' && isBlocked) {
                              await BlockService().unblockUser(
                                  currentUser!.uid, member.uid.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.black.withOpacity(0.8),
                                content: Text(
                                  '${member.username} has been unblocked.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: isFollowing ? 'unfollow' : 'follow',
                              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                            ),
                            PopupMenuItem<String>(
                              value: isBlocked ? 'unblock' : 'block',
                              child: Text(isBlocked ? 'Unblock' : 'Block'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : null, // If user is null or user's UID matches member's UID, hide the buttons
          leading: AvatarWidget(radius: 20, photoURL: member!.photoURL!),
          title: Text(
            username,
            style: TextStyle(fontSize: 15),
          ),
        );
      },
    );
  }
}
