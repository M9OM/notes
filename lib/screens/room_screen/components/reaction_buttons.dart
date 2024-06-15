import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/utils/constants/dilog.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/services/room_service.dart';

import '../../home/home_screen.dart';

class ReactionBouttons extends StatefulWidget {
  final String roomId;

  ReactionBouttons({Key? key, required this.roomId}) : super(key: key);

  @override
  _ReactionBouttonsState createState() => _ReactionBouttonsState();
}

class _ReactionBouttonsState extends State<ReactionBouttons>
    with SingleTickerProviderStateMixin {
  late ChatService chatService;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    chatService = ChatService();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.3), weight: 40),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.3, end: 1.0), weight: 50),
      ],
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLike(String roomId, String userId, bool isLiked) async {
    _animationController.forward(from: 0.0);

    if (isLiked) {
      await chatService.removeLikeRoom(roomId, userId);
    } else {
      await chatService.addLikeRoom(roomId, userId);
    }
    // تشغيل الانميشن عند الضغط على الإعجاب
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.roomId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var roomData = snapshot.data!;
            var likes = List<String>.from(roomData['likes'] ?? []);
            var isLiked = likes.contains(user!.uid);
            var likeCount = likes.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();

                    _handleLike(widget.roomId, user.uid, isLiked);
                  },
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: SvgPicture.asset(
                          isLiked
                              ? AssetsConstants.heartSharpSvg
                              : AssetsConstants.heartOutlinepSvg,
                          width: 35, // تكبير الايقونة عند الضغط
                          color: isLiked
                              ? Colors.red.withOpacity(0.7)
                              : Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        likeCount == 0 ? '' : '$likeCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    showMsgDialog(
                      context: context,
                      title: TranslationConstants.do_u_want_report_this_room
                          .t(context),
                      onTap: () async {
                        await ChatService()
                            .reportRoom(widget.roomId, user.uid.toString());
                        await ChatService()
                            .leaveRoom(widget.roomId, user.uid.toString());
                        navigateScreenWithoutGoBack(
                            context, const HomeScreen());
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icon/info.svg',
                    width: 33, // تكبير الايقونة عند الضغط
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
