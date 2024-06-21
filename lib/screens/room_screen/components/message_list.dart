import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/user_model.dart';
import '../../../services/room_service.dart';
import 'buble.dart';
import 'package:provider/provider.dart';

import '../../../models/message_model.dart';

class MessageList extends StatefulWidget {
  final String roomId;
  final String userId;

  const MessageList({required this.roomId, required this.userId, Key? key})
      : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
  }

  final timeNow = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final user = Provider.of<User?>(context, listen: false);

    if (user == null) {
      return const Center(child: CupertinoActivityIndicator(radius: 14,));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatService.getMessagesWithUserData(widget.roomId, timeNow),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator(radius: 14));
        }

        final messagesWithUserData = snapshot.data!;
        if (_listKey.currentState != null &&
            _listKey.currentState!.widget.initialItemCount !=
                messagesWithUserData.length) {
          final newIndex = messagesWithUserData.length -
              _listKey.currentState!.widget.initialItemCount;
          HapticFeedback.mediumImpact();
          _listKey.currentState!.insertItem(newIndex - 1);
        }

        return AnimatedList(
          reverse: true,
          key: _listKey,
          controller: _listScrollController,
          initialItemCount: messagesWithUserData.length,
          itemBuilder: (context, index, animation) {
            final messageData =
                messagesWithUserData[index]['message'] as Message?;
            final userData = messagesWithUserData[index]['user'] as UserModel?;

            if (messageData == null || userData == null) {
              return const SizedBox.shrink();
            }

            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              child: Buble(
                key: ValueKey(messageData.id.toString()),
                roomId: widget.roomId,
                id: messageData.id.toString(),
                text: messageData.text,
                isMe: messageData.userId == user.uid,
                time: messageData.timestamp,
                likes: messageData.likes,
                username: userData.username ?? 'Unknown',
                avatar: userData.photoURL ?? '',
              ),
            );
          },
        );
      },
    );
  }
}
