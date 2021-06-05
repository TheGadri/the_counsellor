import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_counsellor/screens/complaints/components/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

const String FCMUrl = 'https://fcm.googleapis.com/fcm/send';
const String serverToken =
    'AAAAhZpDToE:APA91bEU93VU6XGKKR4LEn0_KKxodMN1wNwj2-CTHfILEep66J-GLl3nflY7cauB5kWXjW4bnThHSOjca_52u5f7UP3D9CC9YqZfvMmXxEB7wBQrPB_eHFEs7qZz-XNCqAoAKKI7OJkI';

class Commons {
  static Future sendMessage(
      String receiverToken, String message, String senderID) async {
    try {
      final response = await http.post(
        FCMUrl,
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'There\'s a whisper for you. Get in here to hear more',
              'title': 'Your Student sent you a whisper',
              "content_available": true
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sendingTime': DateTime.now().toString(),
              'message': '$message',
              'senderID': '$senderID'
            },
            'to': receiverToken,
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print('EXCEPTION $e\n');
    }
  }

  static Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static showFeedBackCustomDialog(context, bool isError) {
    showDialog(
        context: context,
        builder: (_) => CustomDialogBox(
              title: isError ? "Sorry" : "Success",
              descriptions: isError
                  ? "Couldn't complete this action. Please Try Again"
                  : "Action completed successfully",
              isError: isError,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Close',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (!isError) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else
                      Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  static incrementMessageCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }

  static Future<int> getMessageCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0);
    return counter;
  }

  static clearMessageCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 0);
  }
}
