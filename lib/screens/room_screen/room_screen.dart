import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/home/home_screen.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ui/background.dart';
import 'components/member_list.dart';
import 'components/message_list.dart';
import '../../controllers/loading_controller.dart';
import '../../controllers/chat_controller.dart';
import 'components/apbar.dart';
import 'components/message_input.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../services/room_service.dart';
import 'components/room_drawer.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  late Stream<Rooms?> getRoomData;

  @override
  void initState() {
    getRoomData = ChatService().getRoomById(widget.roomId);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              key: _scaffoldKey,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: StreamBuilder<Rooms?>(
                  stream: getRoomData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: const Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: Text(snapshot.error.toString()),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        title: const Text('Room not found'),
                      );
                    } else {
                      final room = snapshot.data!;
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: () {
                            ChatService().leaveRoom(widget.roomId, room.membersId.firstWhere((element) => element.uid == user!.uid));
                            navigateScreenWithoutGoBack(context, const HomeScreen());
                          },
                          icon: const Icon(Icons.close),
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(room.roomName),
                            Text(
                              '${room.membersId.length} شخص',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              // Navigate to MembersList screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MembersList(
                                    membersData: room.membersData ?? [],
                                  ),
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              AssetsConstants.friendsSvg,
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
                },
                child: Mybackground(
                  screens: [
                    ChatApbar(),
                    Expanded(
                      child: MessageList(roomId: widget.roomId, userId: user!.uid),
                    ),
                    MessageInput(roomId: widget.roomId, userId: user.uid),
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
