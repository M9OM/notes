import 'dart:ui'; // Import for the ImageFilter class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../ui/background.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

TextEditingController nameRoomController = TextEditingController();

class _AddRoomScreenState extends State<AddRoomScreen> {
  String generateUniqueId(String name) {
    String randomLetters = randomAlpha(3); // Generates 3 random letters
    String randomNumbers = randomNumeric(3); // Generates 3 random numbers
    return '$name-$randomLetters$randomNumbers';
  }

  @override
  void initState() {
    nameRoomController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor:Colors.transparent,
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white or any other color
        title: Text(
          'انشاء غرفة',
          style: TextStyle(color: Colors.white), // Set the text color to white or any other color
        ),
      ),
      body: Mybackground(
        screens: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: nameRoomController,
                    decoration: InputDecoration(
                      hintText: 'اسم الغرفة',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Theme.of(context).highlightColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor), // Border color when focused
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Update the text in the TextField
                      });
                    },
                  ),
                ),
                Text(
                  nameRoomController.text.isNotEmpty
                      ? generateUniqueId(nameRoomController.text.replaceAll(' ', '')).trim()
                      : '',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, size: 30, color: Colors.black),
        onPressed: () {
          if (nameRoomController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: const Row(
                  children: [
                    Icon(Icons.error_outline),
                    SizedBox(width: 10),
                    Text(
                      'يرجى إدخال اسم الغرفة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          } else {
            ChatService().createRoom(
              nameRoomController.text,
              generateUniqueId(nameRoomController.text),
              user!.uid,
            );
          }
        },
      ),
    );
  }
}
