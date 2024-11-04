import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationsMgr {

  static Future<void> sendNotificationToUser(
      {required String externalId, required String message}) async {
    await http.post(
      Uri.parse('https://api.onesignal.com/notifications?c=push'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic ${dotenv.env['ONESIGNAL_RESTAPI_KEY']}',
      },
      body: jsonEncode({
        'app_id': '${dotenv.env['ONESIGNAL_KEY']}',
        'include_external_user_ids': [externalId],
        'contents': {'en': message},
      }),
    );
  }
}

