import 'package:flutter/material.dart';

class YoutubeController with ChangeNotifier {

  String videoId = '';


void setVideoId(String videoId) {
  this.videoId = videoId;
  notifyListeners();
}



}
