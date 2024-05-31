import 'dart:ui'; // Import for the ImageFilter class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../controllers/user_future_controller.dart';
import '../../models/user_model.dart';
import '../../ui/background.dart';
import 'components/drawer.dart';
import 'components/rooms_list.dart';
import 'components/rooms_shape.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
            color:
                Colors.white), // Set the icon color to white or any other color
        title: const Text(
          'الغرف',
          style: TextStyle(
              color: Colors
                  .white), // Set the text color to white or any other color
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: UserFutureBuilder(
              uid: user!.uid,
              builder: (context, snapshot) {
                UserModel userData = snapshot.data!;

                return CircleAvatar(
                                backgroundImage: AssetImage('assets/avatar/${userData.photoURL!}.jpeg'),
                );
                // ignore: prefer_const_constructors
              },
              loading: CircularProgressIndicator(),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Mybackground(
        screens: [const Expanded(child: RoomsList())],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, size: 30, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}
