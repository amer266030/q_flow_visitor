import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendNotification(String externalId) async {
   String appId = dotenv.env['OneSignal_App_ID']!; 
   String apiKey = dotenv.env['Rest_API_Key']!;

  final url = "https://api.onesignal.com/notifications?";

  final headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": "Basic $apiKey",
  };

  final body = jsonEncode({
    "app_id": appId,
    "include_external_user_ids": [externalId],
    "headings": {"en": "Amer"},
    "contents": {"en": "He doesn't believe in my abilities...😫"}, 
  });

  final response = await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print("تم إرسال الإشعار بنجاح!");
  } else {
    print("فشل إرسال الإشعار: ${response.body}");
  }
}
