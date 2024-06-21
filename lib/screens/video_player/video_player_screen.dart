import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../utils/constants/color.dart';
import 'video_controls_overlay.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    this.roomId,
    this.isAdmin,
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
  late StreamSubscription<List<Map<String, dynamic>>> _subscription;
  bool _showControls = false;
  Timer? _hideControlsTimer;
  bool _showForwardIcon = false;
  bool _showBackwardIcon = false;
  Duration _totalDuration = Duration.zero;
  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin == false) readData();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        hideControls: true,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    final bool isPlaying = _controller.value.isPlaying;
    final Duration? currentTime = _controller.value.position;
    final Duration? totalDuration = _controller.metadata.duration;

    if (isPlaying != _isPlaying || currentTime != null) {
      setState(() {
        _isPlaying = isPlaying;
        _currentTime = currentTime!;
        _totalDuration = totalDuration!;
      });

      if (widget.isAdmin == true) _updateVideoState();
    }
  }

  Future<void> _updateVideoState() async {
    await Supabase.instance.client.from('video_state').upsert({
      'video_id': widget.videoId + widget.roomId!,
      'is_playing': _isPlaying,
      'current_time': _currentTime.inSeconds,
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

  void _showAndHideControls() {
    setState(() {
      _showControls = true;
    });

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showControls = false;
        _showForwardIcon = false; // Hide forward icon when controls hide
        _showBackwardIcon = false; // Hide backward icon when controls hide
      });
    });
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(targetPosition);
    setState(() {
      _showForwardIcon = true;
    });
    HapticFeedback.mediumImpact();

    _startIconTimer();
    _showAndHideControls();
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(targetPosition);
    setState(() {
      _showBackwardIcon = true;
    });
    HapticFeedback.mediumImpact();

    _startIconTimer();
    _showAndHideControls();
  }

  void _startIconTimer() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _showForwardIcon = false;
        _showBackwardIcon = false;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _subscription.cancel();
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showAndHideControls,
      child: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              YoutubePlayer(
                progressIndicatorColor: primary,
                controller: _controller,
                progressColors: ProgressBarColors(
                  playedColor: primary,
                  handleColor: primary,
                  backgroundColor: primary.withOpacity(0.5),
                ),
                showVideoProgressIndicator: true,
              ),
              widget.isAdmin!
                  ? VideoControlsOverlay(
                      controller: _controller,
                      isPlaying: _isPlaying,
                      showControls: _showControls,
                      showForwardIcon: _showForwardIcon,
                      showBackwardIcon: _showBackwardIcon,
                      currentTime: _currentTime,
                      totalDuration: _totalDuration,
                      onPlayPause: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            HapticFeedback.mediumImpact();

                            _controller.pause();
                          } else {
                            HapticFeedback.mediumImpact();

                            _controller.play();
                          }
                        });
                        _showAndHideControls(); // Reset the timer when the button is pressed
                      },
                      onSeekForward: _seekForward,
                      onSeekBackward: _seekBackward,
                      showControlsFun: () {
                        _showAndHideControls();
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
