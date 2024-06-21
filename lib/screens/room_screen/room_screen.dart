import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/home/home_screen.dart';
import 'package:notes/screens/videoPicker/video_picker_screen.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/dilog.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:provider/provider.dart';
import '../../ui/background.dart';
import '../../utils/constants/lang/translate_constat.dart';
import 'components/member_list.dart';
import 'components/message_list.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/chat_controller.dart';
import 'components/reaction_buttons.dart';
import 'components/videoStream.dart';
import 'components/message_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../services/room_service.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Stream<Rooms?> getRoomData;
  bool _keyboardVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getRoomData = ChatService().getRoomById(widget.roomId);
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: kToolbarHeight, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final user = Provider.of<User?>(context);
    final loadingController = Provider.of<LoadingController?>(context);

    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: Consumer<LoadingController>(
        builder: (context, authController, child) {
          return ModalProgressHUD(
            inAsyncCall: loadingController!.isloading,
            color: Colors.black,
            blur: 5.0,
            opacity: 0.5,
            progressIndicator: CupertinoActivityIndicator(radius: 15),
            child: Scaffold(
              key: _scaffoldKey,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: _keyboardVisible
                    ? Size.fromHeight(0)
                    : Size.fromHeight(kToolbarHeight),
                child: StreamBuilder<Rooms?>(
                  stream: getRoomData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: const Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: Text(snapshot.error.toString()),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showMsgDialogoneBun(
                          context: context,
                          onTap: () {
                            navigateScreenWithoutGoBack(
                                context, const HomeScreen());
                          },
                          title: TranslationConstants.the_cube_has_been_closed.t(context),
                        );
                      });

                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: const Text(''),
                      );
                    } else {
                      final room = snapshot.data!;

                      // Assign the oldest member as admin if not already set
                      ChatService().assignAdminToOldestMember(room);

                      final currentUserUid = user?.uid;
                      bool isIamAdmin = room.membersId.any((member) =>
                          member.isAdmin && member.uid == currentUserUid);

                      return AppBar(
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: () {
                            isIamAdmin
                                ? showMsgDialogEndOrLeave(
                                    context: context,
                                    title: TranslationConstants.end_or_leave.t(context),
                                    end: () async {
                                      loadingController.loading(true);
                                      await ChatService()
                                          .deleteRoom(widget.roomId);
                                      loadingController.loading(false);

                                      navigateScreenWithoutGoBack(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          const HomeScreen());
                                    },
                                    leave: () async {
                                      loadingController.loading(true);
                                      await ChatService().leaveRoom(
                                          widget.roomId, currentUserUid!);
                                      loadingController.loading(false);

                                      navigateScreenWithoutGoBack(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          const HomeScreen());
                                    },
                                  )
                                : showMsgDialog(
                                    context: context,
                                    title: TranslationConstants
                                        .do_you_want_to_exit
                                        .t(context),
                                    onTap: () async {
                                      loadingController.loading(true);
                                      await ChatService().leaveRoom(
                                          widget.roomId,
                                          currentUserUid.toString());
                                      loadingController.loading(false);

                                      navigateScreenWithoutGoBack(
                                          context, const HomeScreen());
                                    },
                                  );
                          },
                          icon: const Icon(Icons.close),
                        ),
                        title: SvgPicture.asset(
                          AssetsConstants.logoSvg,
                          color: primary,
                          width: 35,
                        ),
                        actions: [
                          Row(
                            children: [
                              Text(
                                room.membersData!.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  showRoomMembersDialog(
                                    context,
                                    MembersList(
                                      membersData: room.membersData ?? [],
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  AssetsConstants.friendsSvg,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          if (isIamAdmin)
                            IconButton(
                              onPressed: () async {
                                final selectedVideo = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPickerScreen(
                                        roomId: widget.roomId),
                                  ),
                                );
                                if (selectedVideo != null) {
                                  // Handle selected video
                                }
                              },
                              icon: const Icon(
                                Icons.play_circle,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    FocusScope.of(context).hasFocus
                        ? _keyboardVisible = false
                        : false;
                  });
                },
                child: Stack(
                  children: [
                    Mybackground(
                      mainAxisAlignment: MainAxisAlignment.center,
                      screens: [
                        _keyboardVisible
                            ? SizedBox(height: 0)
                            : SizedBox(height: 110),
                        VideoStream(
                          roomId: widget.roomId,
                        ),
                        Expanded(
                          child: MessageList(
                              roomId: widget.roomId, userId: user!.uid),
                        ),
                        MessageInput(roomId: widget.roomId, userId: user.uid),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      bottom: 120,
                      child: ReactionButtons(roomId: widget.roomId),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
