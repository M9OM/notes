import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/members_model.dart';
import 'package:notes/models/rooms_model.dart';
import 'package:provider/provider.dart';
import 'package:notes/services/room_service.dart';
import '../../video_player/video_player_screen.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  late Stream<Rooms?> _roomStream;

  @override
  void initState() {
    super.initState();
    _roomStream = ChatService().getRoomStream(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<Rooms?>(
      stream: _roomStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        var roomData = snapshot.data!;
        var videoId = roomData.videoId ?? '';
        List<Member> memberList = roomData.membersId;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (videoId.isNotEmpty)
              Stack(
                children: [
                  VideoPlayerScreen(
                    videoId: videoId,
                    roomId: widget.roomId,
                    isAdmin: memberList.isNotEmpty && memberList[0].uid == user.uid,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        if (memberList.isNotEmpty && memberList[0].uid == user.uid) {
                          ChatService().setVideo(widget.roomId, '');
                        }
                      },
                      icon: Icon(
                        Icons.close,
                        color: memberList.isNotEmpty && memberList[0].uid == user.uid
                            ? Colors.white
                            : Colors.grey,
                      ),
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
