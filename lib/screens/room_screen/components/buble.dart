import 'dart:ui' as ui;

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notes/controllers/lang_controller.dart';
import 'package:notes/ui/avatar_widget.dart';
import '/models/message_model.dart';
import '../../../services/room_service.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/color.dart';

class Buble extends StatefulWidget {
  const Buble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.time,
    required this.likes,
    required this.id,
    required this.roomId,
    required this.username,
    required this.avatar,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final Timestamp time;
  final List<Likes> likes;
  final String id;
  final String roomId;
  final String username;
  final String avatar;

  @override
  _BubleState createState() => _BubleState();
}

class _BubleState extends State<Buble> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  List<Likes> _likes = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 2.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 2.0, end: 1.0), weight: 80),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _likes = widget.likes;
  }

  void _addLike(Likes like) {
    setState(() {
      _likes.add(like);
      _animationController.forward(from: 0.0);
    });
  }

  void _removeLike(Likes like) {
    setState(() {
      _likes.removeWhere((element) =>
          element.userId == like.userId && element.emoji == like.emoji);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<User?>(context);
    final lang = Provider.of<LanguageController?>(context);
    DateTime dateTime = widget.time.toDate();
    DateFormat dateFormat = DateFormat("hh:mm a", "${lang!.currentLanguage}");
    String username = widget.username;
              if (username.length > 13) {
                username = username.substring(0, 13)+'';
              }


    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          children: [
            Row(
              textDirection: ui.TextDirection.ltr,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: AvatarWidget(
                      radius: 15, photoURL: widget.avatar.toString()),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 290),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: theme.highlightColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: RichText(
  textDirection: ui.TextDirection.ltr,
  text: TextSpan(
    style: TextStyle(fontFamily: 'arabic'),
    children: [
      WidgetSpan(
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Text(
            "${username.trim()}: ",
            style: yourNameMsgStyle, // Style for the username
          ),
        ),
      ),
      TextSpan(
        text: widget.text.trim(),
        style: yourMsgStyle, // Style for the message text
      ),
    ],
  ),
)

                                      
                        
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
