import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _roomStream;

  @override
  void initState() {
    super.initState();
    _roomStream = ChatService().getRoomStream(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _roomStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available'));
        }

        var roomData = snapshot.data!.data();
        var videoId = roomData?['videoId'] ?? '';

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 110),
            if (videoId.isNotEmpty)
              Stack(
                children: [
                  VideoPlayerScreen(videoId: videoId),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        ChatService().setVideo(widget.roomId, '');
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
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
