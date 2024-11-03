import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationsMgr {
  static Future<void> sendNotification(
      {required String msg, required NotificationSegment segment}) async {
    await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic ${dotenv.env['OneSignal_RESTAPI_KEY']}',
      },
      body: jsonEncode({
        'app_id': '${dotenv.env['OneSignal_App_ID']}',
        'included_segments': [segment.name],
        'contents': {'en': msg},
      }),
    );
  }

  static Future<void> sendNotificationToUser(
      String externalId, String message) async {
    await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic ${dotenv.env['OneSignal_RESTAPI_KEY']}',
      },
      body: jsonEncode({
        'app_id': '${dotenv.env['OneSignal_App_ID']}',
        'include_external_user_ids': [externalId],
        'contents': {'en': message},
      }),
    );
  }
}

enum NotificationSegment { customer, employee }
