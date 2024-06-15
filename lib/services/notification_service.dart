import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NotificationsService {
  
  Future<void> sendNotification(List<String> playerIds, String message, String name) async {
    const String oneSignalAppId = "4e94d188-402a-4a57-bfd8-8531f75f4a69";
    const String oneSignalApiKey =
        "M2Y3ZDI3NTEtODVkYi00YmVjLTgzNmYtOTJmMzFmNjE2ZTA1";

    final Map<String, dynamic> notification = {
      'app_id': oneSignalAppId,
      'include_player_ids': playerIds,
      'contents': {'en': message},
      'headings': {'en': name},

    };

    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $oneSignalApiKey',
      },
      body: json.encode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  Future<void> savePlayerIdToFirestore(String playerId, String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'playerId': playerId,
    }).then((_) {
      print("Player ID updated successfully");
    }).catchError((error) {
      print("Failed to update player ID: $error");
    });
  }
}
