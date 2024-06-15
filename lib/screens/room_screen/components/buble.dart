import 'dart:ui' as ui;

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

    DateTime dateTime = widget.time.toDate();
    DateFormat dateFormat = DateFormat("hh:mm a", "ar");

    // Count occurrences of each emoji
    Map<String, int> emojiCount = {};
    for (var like in _likes) {
      if (emojiCount.containsKey(like.emoji)) {
        emojiCount[like.emoji] = emojiCount[like.emoji]! + 1;
      } else {
        emojiCount[like.emoji] = 1;
      }
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
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/avatar/${widget.avatar}.jpeg'),
                    radius: 15,
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 270),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onDoubleTap: () async {
                            HapticFeedback.mediumImpact();
                            final like = Likes(userId: user!.uid, emoji: '💚');

                            await ChatService().reactionMsg(
                              like,
                              user.uid,
                              widget.id,
                              widget.roomId,
                            );
                            if (!_likes.any((l) =>
                                l.userId == like.userId &&
                                l.emoji == like.emoji)) {
                              _addLike(like);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.highlightColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.username.trim(),
                                  style: yourNameMsgStyle,
                                ),
                                Text(
                                  widget.text.trim(),
                                  style: yourMsgStyle,
                                ),
                                Text(
                                  dateFormat.format(dateTime),
                                  style: yourMsgtimeStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (emojiCount.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: widget.isMe
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: emojiCount.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          final like = Likes(userId: user!.uid, emoji: '💚');
                          _removeLike(like);

                          ChatService().removeReactionMsg(
                            like,
                            user.uid,
                            widget.id,
                            widget.roomId,
                          );
                        },
                        child: ScaleTransition(
                          scale: entry.key == '💚'
                              ? _scaleAnimation
                              : const AlwaysStoppedAnimation(1.0),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${entry.key}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${entry.value > 1 ? entry.value : '1'}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
