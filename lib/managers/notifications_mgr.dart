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
        'app_id': '9ef08024-c628-4bca-a101-1a15e7ee892c',
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
        'app_id': '9ef08024-c628-4bca-a101-1a15e7ee892c',
        'include_external_user_ids': [externalId],
        'contents': {'en': message},
      }),
    );
  }
}

enum NotificationSegment { customer, employee }
