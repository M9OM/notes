import 'package:flutter/material.dart';
import 'package:notes/controllers/youtube_controller.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';

import '../../video_player/video_player_screen.dart';

class ChatApbar extends StatelessWidget {
  ChatApbar({super.key});

  @override
  Widget build(BuildContext context) {
    final youtubeController = Provider.of<YoutubeController>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [SizedBox(height: 110,),
        youtubeController.videoId.isNotEmpty
            ? Stack(
              children: [
                VideoPlayerScreen(videoId: youtubeController.videoId),
                IconButton(
                    onPressed: () {
                      youtubeController.setVideoId('');
                    },
                    icon: Icon(Icons.close)),
              ],
            )
            : SizedBox.shrink(),

      ],
    );
  }
}
