import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/chat_screen/components/buble.dart';
import 'package:provider/provider.dart';

import '../../../models/message_model.dart';
import '../../../services/chat_service.dart';

class MessageList extends StatefulWidget {
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

  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final user = Provider.of<User?>(context);
    return StreamBuilder<List<Message>>(
      stream: chatService.getMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final messages = snapshot.data!;

        if (_listKey.currentState != null &&
            _listKey.currentState!.widget.initialItemCount != messages.length) {
          final newIndex =
              messages.length - _listKey.currentState!.widget.initialItemCount;
          HapticFeedback.mediumImpact();

          _listKey.currentState!.insertItem(newIndex - 1);
        }

        return AnimatedList(
          reverse: true,
          key: _listKey,
          controller: _listScrollController,
          initialItemCount: messages.length,
          itemBuilder: (context, index, animation) {
            return SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: Buble(
                  key: ValueKey(messages[index].id.toString(),),
                  id: messages[index].id.toString(),
                  text: messages[index].text,
                  isMe: messages[index].userId == user!.uid,
                  time:messages[index].timestamp,
                  likes:messages[index].likes
                ));
          },
        );
      },
    );
  }
}
