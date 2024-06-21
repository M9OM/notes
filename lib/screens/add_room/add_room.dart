import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:notes/utils/enum/RoomType.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../controllers/room_controller.dart';
import '../../route/route_screen.dart';
import '../../ui/background.dart';

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

class _AddRoomScreenBodyState extends State<AddRoomScreenBody>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameRoomController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RoomType selectedRoomType = RoomType.games;
  bool isPrivateRoom = false;

  String generateUniqueId(String name) {
    String randomLetters = randomAlpha(3); // Generates 3 random letters
    String randomNumbers = randomNumeric(3); // Generates 3 random numbers
    return '$name-$randomLetters$randomNumbers';
  }

  @override
  void dispose() {
    nameRoomController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final loadingController = Provider.of<LoadingController?>(context);
    final roomController = Provider.of<RoomController>(context);
    String roomId = generateUniqueId(nameRoomController.text);

    return ModalProgressHUD(
      inAsyncCall: loadingController!.isloading,
      color: Colors.black,
      blur: 5.0,
      opacity: 0.5,
      progressIndicator: CupertinoActivityIndicator(radius: 15),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0, // Remove shadow
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // Set the icon color to white or any other color
          title: Text(
            TranslationConstants.create_cube.t(context),
            style: const TextStyle(
              color: Colors.white,
            ), // Set the text color to white or any other color
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Mybackground(
              mainAxisAlignment: MainAxisAlignment.start,
              screens: [
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    TranslationConstants.name_cube.t(context),
                    style: const TextStyle(fontSize: 19),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: nameRoomController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          35), // Limit to 35 characters
                    ],
                    decoration: InputDecoration(
                      hintText:
                          TranslationConstants.ex_come_tomy_cube.t(context),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Theme.of(context).highlightColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ), // Border color when focused
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    TranslationConstants.category.t(context),
                    style: const TextStyle(fontSize: 19),
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
                            ),
                          ),
                          child: Text(
                            getTypeName(type, context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TranslationConstants.private_cube.t(context),
                        style: const TextStyle(fontSize: 19),
                      ),
                      Switch(
                        activeColor: primary,
                        value: isPrivateRoom,
                        onChanged: (value) {
                          setState(() {
                            isPrivateRoom = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear,
                  child: isPrivateRoom
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: TranslationConstants.enter_password
                                  .t(context),
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Theme.of(context).highlightColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ), // Border color when focused
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(
                  height: ScreenSizeExtension(context).screenHeight * 0.5,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.arrow_forward_ios,
              size: 25, color: Colors.black),
          onPressed: () async {
            if (nameRoomController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline),
                      const SizedBox(width: 10),
                      Text(
                        TranslationConstants.please_enter_cube_name.t(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final currentUserData = await AuthService().getCurrentUserData();
              loadingController!.loading(true);
              await ChatService().createRoom(
                nameRoomController.text,
                roomId,
                user!.uid,
                currentUserData!.photoURL!,
                roomType: selectedRoomType.name,
                isPrivate: isPrivateRoom,
                password: isPrivateRoom ? passwordController.text : null,
              );
              loadingController!.loading(false);

              navigateScreenWithoutGoBack(context, RoomScreen(roomId: roomId));
            }
          },
        ),
      ),
    );
  }
}
