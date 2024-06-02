import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/add_room/add_room.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import '../../controllers/user_stream_controller.dart';
import '../../models/user_model.dart';
import '../../route/route_screen.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.black.withOpacity(0.9),
        backgroundColor: Colors.black.withOpacity(0.1),
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
            child: UserStreamBuilder(
              uid: user!.uid,
              builder: (context, snapshot) {
                UserModel userData = snapshot.data!;

                return CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/avatar/${userData.photoURL!}.jpeg'),
                );
                // ignore: prefer_const_constructors
              },
              loading: const CircleAvatar(),
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
        screens: const [Expanded(child: RoomsList())],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, size: 30, color: Colors.black),
        onPressed: () {
          navigateToCreateRoomScreen(context, const AddRoomScreen());
        },
      ),
    );
  }
}
