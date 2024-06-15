import 'dart:convert';
import 'package:http/http.dart' as http;


class EmailService {
  static const String _serviceId = 'service_8mgr8hm';
  static const String _templateId = 'template_abtkvgm';
  static const String _userId = 't_6l0VUQmnW2zWKjN';

  static Future<void> sendEmail({
    required String name,
    required String message,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    // Convert products to HTML table rows

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost',
      },
      body: jsonEncode({
        'to':[],
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _userId,
        'template_params': {
          'name':name,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully!');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }
}
