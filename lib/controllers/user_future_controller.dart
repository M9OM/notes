import 'package:flutter/material.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/services/auth_service.dart';

class UserFutureBuilder extends StatelessWidget {
  final String uid;
  final Widget Function(BuildContext, AsyncSnapshot) builder;
  final Widget loading;

  const UserFutureBuilder({
    required this.uid,
    required this.builder,
    required this.loading
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: AuthService().getUserDataByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: loading);
        } else {
          return builder(context, snapshot);
        }
      },
    );
  }
}
