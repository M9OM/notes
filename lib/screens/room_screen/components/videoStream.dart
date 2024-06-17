import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:provider/provider.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/services/room_service.dart';

import '../../video_player/video_player_screen.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/services/room_service.dart';
import '../../video_player/video_player_screen.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  late Stream<Rooms> _roomStream;

  @override
  void initState() {
    super.initState();
    _roomStream = ChatService().getRoomStream(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamBuilder<Rooms>(
      stream: _roomStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var roomData = snapshot.data!;
        var videoId = roomData.videoId ?? '';
        List<Member> member_list = roomData.membersId ?? [];

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 110),
            if (videoId.isNotEmpty)
              Stack(
                children: [
                  VideoPlayerScreen(videoId: videoId,roomId:widget.roomId, isAdmin:member_list[0].uid == user!.uid
                            ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        member_list[0].uid == user!.uid
                            ? ChatService().setVideo(widget.roomId, '')
                            : null;
                      },
                      icon: Icon(Icons.close,
                          color: member_list[0].uid == user!.uid
                              ? Colors.white
                              : Colors.grey),
                    ),
                  )
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
