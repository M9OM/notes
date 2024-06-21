import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/constants/color.dart';

class VideoControlsOverlay extends StatelessWidget {
  final YoutubePlayerController controller;
  final bool isPlaying;
  final bool showControls;
  final bool showForwardIcon;
  final bool showBackwardIcon;
  final Duration currentTime;
  final Duration totalDuration;
  final Function() onPlayPause;
  final Function() onSeekForward;
  final Function() onSeekBackward;
  final Function() showControlsFun;

  const VideoControlsOverlay({
    Key? key,
    required this.controller,
    required this.isPlaying,
    required this.showControls,
    required this.showForwardIcon,
    required this.showBackwardIcon,
    required this.currentTime,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.showControlsFun,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showControlsFun();
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedOpacity(
            opacity: showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          if (showControls)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                child: IconButton(
                  key: ValueKey<bool>(isPlaying),
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Color.fromARGB(255, 215, 215, 215),
                  ),
                  onPressed: onPlayPause,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onDoubleTap: onSeekBackward,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.3,
                height: double.infinity,
                child: AnimatedOpacity(
                  opacity: showBackwardIcon ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onDoubleTap: onSeekForward,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.3,
                height: double.infinity,
                child: AnimatedOpacity(
                  opacity: showForwardIcon ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
                    if (showControls)

          Positioned(
            bottom: 9,
            left: 0,
            right: 0,
            child: Slider(
              min: 0.0,
              max: totalDuration.inSeconds.toDouble(),
              value: currentTime.inSeconds.toDouble(),
              activeColor: primary,
              inactiveColor: primary.withOpacity(0.5),
              onChanged: (value) {
                showControlsFun();
                controller.seekTo(Duration(seconds: value.toInt()));
              },
            ),
          ),
                    if (showControls)

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(currentTime),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    _formatDuration(totalDuration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
