import 'package:flutter/material.dart';
import 'package:notes/screens/auth/login_screen.dart';
import 'package:notes/services/notification_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) {
      print(OneSignal.User.pushSubscription.id);
      NotificationsService().savePlayerIdToFirestore(
          OneSignal.User.pushSubscription.id.toString(), user.uid);
    }
    return user == null ? const LoginScreen() : const HomeScreen();
  }
}
