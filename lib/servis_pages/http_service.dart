
import 'dart:convert';

import 'package:http/http.dart';
import 'package:instagram_clone/models/member_model.dart';

class  Network {

  static String BASE = "fcm.googleapis.com";
  static String api = "/fcm/send";
  static Map<String , String> headers = {
    "Authorization" : "key=AAAAehEkkmw:APA91bHp6tbhOgP2rxBkl-ulfKQPOu1rT1iuqzaKgLDxUV_bRvsgVS4Tq2LsKiGBhJGkHoMzF3OyRS_2uxepy8qkSLY6iYOw0gAaBKHjXytqTMq5farIS3PnDbVbsANRkZLzdbDuzkQa",
    "Content-Type" : "application/json"
  };

  static Future<String?> POST(Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, api);
    var response = await post(uri, headers : headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future sendNotification(String name, Member someone) async {
    Map<String, dynamic> params = {
        "notification":
        {
          "body": name + " is your new subscriber",
          "title": "😎 New Followers 😎"
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        },
        "to": someone.device_token
    };
    POST(params);
  }

}