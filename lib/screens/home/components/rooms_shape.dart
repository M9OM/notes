import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class RoomsShape extends StatefulWidget {
  const RoomsShape({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.roomId,
    this.membersData,
    required this.is_playing,
    this.isPrivate,
    this.password,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final String roomId;
  final List<UserModel>? membersData;
  final bool is_playing;
  final bool? isPrivate;
  final String? password;

  @override
  State<RoomsShape> createState() => _RoomsShapeState();
}

final TextEditingController _passwordController = TextEditingController();

class _RoomsShapeState extends State<RoomsShape> {
  Future<void> _showPasswordDialog(
      BuildContext context, String roomPassword) async {
    bool _passwordError = false;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: AlertDialog(
                backgroundColor: Colors.black,
                title: Text(TranslationConstants.enter_password.t(context)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          _passwordError = false; // Reset error when user types
                        });
                      },
                      decoration: InputDecoration(
                        hintText: TranslationConstants.password.t(context),
                        errorText: _passwordError ? 'Wrong Password' : null,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(TranslationConstants.close.t(context),
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      TranslationConstants.join.t(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_passwordController.text == roomPassword) {
                        final user = FirebaseAuth.instance.currentUser;
                        await ChatService().joinRoom(widget.roomId, user!.uid);
                        navigateScreenWithoutGoBack(
                            // ignore: use_build_context_synchronously
                            context,
                            RoomScreen(roomId: widget.roomId));
                      } else {
                        setState(() {
                          _passwordError = true; // Show error message
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final loadingController = Provider.of<LoadingController?>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: ScreenSizeExtension(context).screenWidth * 0.95,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.09),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.imageUrl.contains('http')
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: primary.withOpacity(0.3),
                                  width: 65,
                                  height: 65,
                                ),
                                width: 65,
                                height: 65,
                                imageUrl: widget.imageUrl,
                              )
                            : Image.asset(
                                fit: BoxFit.fill,
                                width: 65,
                                height: 65,
                                'assets/avatar/${widget.imageUrl}.jpeg',
                              ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ScreenSizeExtension(context).screenWidth *
                                      0.6, // Adjust width to avoid overflow
                            ),
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ScreenSizeExtension(context).screenWidth *
                                      0.6, // Adjust width to avoid overflow
                            ),
                            child: Text(
                              widget.subtitle,
                              style: TextStyle(
                                color: primary,
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(children: [
                    if (widget.is_playing)
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 97, 32, 210),
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          'assets/json/playing.json',
                          width: 25,
                        ),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.isPrivate ?? false)
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 64, 50),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock,
                            size: 15,
                            color: Colors.grey[200],
                          )),
                  ])
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ...List.generate(
                    widget.membersData!.length > 3
                        ? 3
                        : widget.membersData!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: AvatarWidget(
                        radius: 15,
                        photoURL: widget.membersData![index].photoURL!,
                      ),
                    ),
                  ),
                  if (widget.membersData!.length > 3)
                    Text(
                      '  ${TranslationConstants.and.t(context)} ${widget.membersData!.length - 3} ${TranslationConstants.others.t(context)}',
                    ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  if (widget.isPrivate ?? false) {
                    await _showPasswordDialog(context, widget.password!);
                  } else {
                    loadingController!.loading(true);
                    await ChatService().joinRoom(widget.roomId, user!.uid);
                    navigateScreenWithoutGoBack(
                        context, RoomScreen(roomId: widget.roomId));
                    loadingController.loading(false);
                  }
                },
                child: Center(
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    width: ScreenSizeExtension(context).screenWidth * 0.95,
                    child: Text(
                      TranslationConstants.join.t(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
