import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  final String videoId;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late DatabaseReference _videoRef;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
      ),
    );

    _videoRef = FirebaseDatabase.instance.reference().child('video');
    _videoRef.onValue.listen((event) {
      // Update video playback based on data from Firebase
      // Implement synchronization logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: AspectRatio(
          aspectRatio: 16/9, // You can adjust this ratio as needed
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
        
      ),
    );
  }
}