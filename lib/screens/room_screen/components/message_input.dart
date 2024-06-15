import 'package:flutter/material.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:provider/provider.dart';
import '../../../controllers/chat_controller.dart';
import '../../../utils/constants/color.dart';
import '../../../utils/constants/lang/translate_constat.dart';
import '../../videoPicker/video_picker_screen.dart';

class MessageInput extends StatefulWidget {
  final String userId;
  final String roomId;

  MessageInput({required this.userId, required this.roomId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with SingleTickerProviderStateMixin {
  late ChatController chatController;
  late ValueNotifier<bool> isInputEmpty;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    chatController = Provider.of<ChatController>(context, listen: false);
    isInputEmpty = ValueNotifier<bool>(true);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    chatController.messageController.addListener(() {
      bool isEmpty = chatController.messageController.text.isEmpty;
      if (isEmpty != isInputEmpty.value) {
        isInputEmpty.value = isEmpty;
        if (!isEmpty) {
          _animationController.forward(from: 0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    isInputEmpty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              style: const TextStyle(),
              controller: chatController.messageController,
              decoration: InputDecoration(
                hintText: TranslationConstants.write.t(context),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: inputBgColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                  ),
                ),
                hintStyle: const TextStyle(),
                filled: true,
                fillColor: inputBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.indigoAccent,
                    width: 2,
                  ),
                ),
                prefixIcon: ValueListenableBuilder<bool>(
                  valueListenable: isInputEmpty,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // InkWell(
                        //   onTap: () async {
                        //     final selectedVideo = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => VideoPickerScreen()),
                        //     );
                        //     if (selectedVideo != null) {
                        //       // Handle selected video
                        //     }
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Container(
                        //         padding: const EdgeInsets.all(9),
                        //         decoration: BoxDecoration(
                        //           color: theme.primaryColor,
                        //           shape: BoxShape.circle,
                        //         ),
                        //         child: Icon(
                        //           Icons.play_circle_fill,
                        //           color: Colors.black,
                        //         )),
                        //   ),
                        // ),
                        value
                            ? const SizedBox.shrink()
                            : ScaleTransition(
                                scale: _scaleAnimation,
                                child: RotationTransition(
                                  turns: _rotationAnimation,
                                  child: InkWell(
                                    onTap: () {
                                      chatController.sendMessage(widget.roomId,widget.userId);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/send.png',
                                          width: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
