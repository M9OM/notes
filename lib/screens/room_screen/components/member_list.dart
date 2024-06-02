import 'package:flutter/material.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/ui/background.dart';

import '../../../models/user_model.dart';

class MembersList extends StatelessWidget {
  MembersList({super.key, required this.membersData});
  List<UserModel?> membersData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            '${membersData.length} شخص',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          )),
      body: Mybackground(screens: [
        Expanded(
            child: ListView.builder(
          itemCount: membersData.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: Icon(Icons.person_add),
              leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/avatar/${membersData[index]!.photoURL}.jpeg')),
              title: Text(membersData[index]!.username.toString()),
              subtitle:
                  Text(membersData[index]!.isAdmin == true ? 'المشرف' : ''),
            );
          },
        ))
      ]),
    );
  }
}
