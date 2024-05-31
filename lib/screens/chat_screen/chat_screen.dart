import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/chat_screen/components/message_list.dart';
import 'package:provider/provider.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/chat_controller.dart';
import 'components/apbar.dart';
import 'components/message_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: Consumer<LoadingController>(
          builder: (context, authController, child) {
        return ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(),
          inAsyncCall: authController.isloading,
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  ChatApbar(),
                  Expanded(child: MessageList()),
                  MessageInput(roomId: roomId, userId: user!.uid),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
