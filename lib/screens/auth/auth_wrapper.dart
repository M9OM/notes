import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../add_room/add_room.dart';
import '../home/home_screen.dart';
import '../main_screen/mian_screen.dart';
import '../notes_screen/note_screen.dart';
import '../profile/profile_screen.dart';
import 'sign_in_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return  SignInScreen();
    } else {
      return  HomeScreen();
    }
  }
}
