import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/enum/RoomType.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../controllers/room_controller.dart';
import '../../route/route_screen.dart';
import '../../ui/background.dart';
import 'components/avatar_room_list.dart';

class AddRoomScreen extends StatelessWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddRoomScreenBody();
  }
}

class AddRoomScreenBody extends StatefulWidget {
  @override
  State<AddRoomScreenBody> createState() => _AddRoomScreenBodyState();
}

class _AddRoomScreenBodyState extends State<AddRoomScreenBody> {
  final TextEditingController nameRoomController = TextEditingController();
  RoomType selectedRoomType = RoomType.games;

  String generateUniqueId(String name) {
    String randomLetters = randomAlpha(3); // Generates 3 random letters
    String randomNumbers =
        randomNumeric(3); // Generates 3 random numbers
    return '$name-$randomLetters$randomNumbers';
  }

  @override
  void dispose() {
    nameRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final roomController = Provider.of<RoomController>(context);
String roomId =generateUniqueId(nameRoomController.text);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Set the icon color to white or any other color
        title: const Text(
          'انشاء غرفة',
          style: TextStyle(
            color: Colors.white,
          ), // Set the text color to white or any other color
        ),
      ),
      body: Mybackground(
        screens: [
          const SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameRoomController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    45), // Limit to 30 characters
              ],
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
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .primaryColor), // Border color when focused
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Update the text in the TextField
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'التصنيف',
              style: TextStyle(fontSize: 19),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: RoomType.values.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoomType = type;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: selectedRoomType == type
                              ? primary
                              : Colors.grey,
                        )),
                    child: Text(
                      getTypeName(type),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'صورة العرض',
              style: TextStyle(fontSize: 19),
            ),
          ),

          InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const AvatarRoomList();
                  },
                );
              },
              child: roomController.pathImageRoomAvatar == ''
                  ? Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: GetThemeData(context).theme.highlightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/avatar/${roomController.pathImageRoomAvatar}.jpeg'),
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                      ),
                    )),

          // Center(
          //   child: Text(
          //     nameRoomController.text.isNotEmpty
          //         ? generateUniqueId(
          //                 nameRoomController.text.replaceAll(' ', ''))
          //             .trim()
          //         : '',
          //     style: const TextStyle(fontSize: 16, color: Colors.white),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.arrow_forward_ios, size: 25, color: Colors.black),
        onPressed: () async {
          if (nameRoomController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Row(
                  children: const [
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
            await ChatService().createRoom(
              nameRoomController.text,
              roomId,
              user!.uid,
              roomController.pathImageRoomAvatar,
              roomType: selectedRoomType.name,
            );

            navigateScreenWithoutGoBack(context, RoomScreen(roomId: roomId));
          }
        },
      ),
    );
  }
}
