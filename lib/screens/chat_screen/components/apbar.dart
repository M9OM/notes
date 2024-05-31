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
      children: [
        const SizedBox(height: 55),
        youtubeController.videoId.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    VideoPlayerScreen(videoId: youtubeController.videoId),
                    IconButton(
                        onPressed: () {
                          youtubeController.setVideoId('');
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
              )
            : SizedBox.shrink(),

        // CircleAvatar(
        //   radius: 25,
        //   backgroundColor: primary,
        //   child: ClipOval(
        //     child: SizedBox(
        //       width: 35,
        //       height: 35,
        //       child: Image.network(
        //         'https://cdn-icons-png.flaticon.com/512/249/249413.png',
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: [
        //       Text(
        //         'انا ياسر احب البرمجة!',
        //         style: TextStyle(
        //           fontSize: 18,
        //           color: Colors.white,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //       Text('@yasser'),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
