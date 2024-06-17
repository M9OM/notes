import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:notes/utils/constants/color.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    this.roomId,  this.isAdmin,

  }) : super(key: key);

  final String videoId;
  final String? roomId;
final bool? isAdmin;
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false;
  double _currentTime = 1.0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      
      flags: YoutubePlayerFlags(hideControls: !widget.isAdmin!,mute: false, showLiveFullscreenButton: false),
    );

    _controller.addListener(_videoListener);

    readData();
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying || _controller.value.position.inSeconds.toDouble() != _currentTime) {
      _isPlaying = _controller.value.isPlaying;
      _currentTime = _controller.value.position.inSeconds.toDouble();
      _updateVideoState();
    }
  }

  Future<void> _updateVideoState() async {
    await Supabase.instance.client.from('video_state').upsert({
      'video_id': widget.videoId + widget.roomId!,
      'is_playing': _isPlaying,
      'current_time': _currentTime,
    });
  }

  Future<void> readData() async {
    final subscription = Supabase.instance.client
        .from('video_state')
        .stream(primaryKey: ['video_id'])
        .eq('video_id', widget.videoId + widget.roomId!)
        .execute();

    subscription.listen((List<Map<String, dynamic>> data) {
      if (data.isNotEmpty) {
        final item = data.first;
        final isPlaying = item['is_playing'] as bool;
        final currentTime = item['current_time'] as double;

        if (isPlaying != _controller.value.isPlaying) {
          if (isPlaying) {
            _controller.play();
          } else {
            _controller.pause();
          }
        }

        if ((currentTime - _controller.value.position.inSeconds).abs() > 1) {
          _controller.seekTo(Duration(seconds: currentTime.toInt()));
        }
      } else {
        print('No data found.');
      }
    }).onError((error) {
      print('Error: $error');
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          progressIndicatorColor: primary,
          controller: _controller,
          progressColors: ProgressBarColors(
            playedColor: primary,
            handleColor: primary,
            backgroundColor: primary.withOpacity(0.5),
          ),
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
