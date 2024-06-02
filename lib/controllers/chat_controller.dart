import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '/utils/constants/color.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  bool _isSending = false;
    bool get isSending => _isSending;

  bool _isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _recordingPath;

  bool get isRecording => _isRecording;

  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }
  Future<void> _init() async {
    await _requestPermissions();
  }
  ChatController() {
    _init();
  }

  void sendMessage(String roomId,String userId) async {
    if (messageController.text.isEmpty || _isSending) return;

    _isSending = true;
    notifyListeners();

     _chatService.sendMessage(roomId,messageController.text, userId);
    messageController.clear();

    _isSending = false;
    notifyListeners();
  }
Future<void> toggleRecording(BuildContext context) async {
  _requestMicrophonePermission(context);
  if (_isRecording) {
    // Stop recording
    if (await _audioRecorder.isRecording()) {
      _recordingPath = await _audioRecorder.stop();
      _isRecording = false;
    }
  } else {
    // Request microphone permission
    final bool hasPermission = await _requestPermissions();
    if (!hasPermission) {
      print('Microphone permission not granted.');
      // Handle permission denial here (e.g., show a message to the user)
      return;
    }

    // Start recording
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String filePath = p.join(appDocumentsDir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.wav');
    await _audioRecorder.start(
      const RecordConfig(),
      path: filePath,
    );
    _isRecording = true;
    _recordingPath = null;
  }
  notifyListeners();
}

Future<bool> _requestPermissions() async {
  final Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.storage,
  ].request();
  return statuses[Permission.microphone] == PermissionStatus.granted;
}

  Future<void> playRecording() async {
    if (_recordingPath != null) {
      await _audioPlayer.play(DeviceFileSource(_recordingPath!));
    }
  }

  Future<void> sendAudioMessage(String userId) async {
    if (_recordingPath == null) return;

    try {
      // Upload the recorded audio to Firebase Storage
      File file = File(_recordingPath!);
      String fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      Reference storageReference = FirebaseStorage.instance.ref().child('chat_audio').child(fileName);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded audio file
      String audioUrl = await taskSnapshot.ref.getDownloadURL();

      // Send the message to Firestore
      await FirebaseFirestore.instance.collection('chats').add({
        'userId': userId,
        'audioUrl': audioUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the recorded file path after sending
      _recordingPath = null;
      notifyListeners();
    } catch (e) {
      print('Error sending audio message: $e');
    }
  }
void _requestMicrophonePermission(BuildContext context) async {
  final PermissionStatus status = await Permission.microphone.request();
  if (status != PermissionStatus.granted) {
  } else {
    // Microphone permission granted
    // You can proceed with recording or any other operation requiring microphone access
  }
}

  Widget recordingButton(BuildContext context) {
    return IconButton(
      onPressed:() {
        toggleRecording(context);
      },
      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
    );
  }

  Widget playButton() {
    return IconButton(
      onPressed: playRecording,
      icon: Icon(Icons.play_arrow),
    );
  }

  Widget sendAudioButton(String userId) {
    return IconButton(
      onPressed: () => sendAudioMessage(userId),
      icon: Icon(Icons.send),
    );
  }
}



