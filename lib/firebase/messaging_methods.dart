import "dart:convert";
import "package:http/http.dart" as http;
import "package:upoint/firebase/access_firebase_token.dart";
import "package:upoint/models/user_model.dart";

import "../secret.dart";

class MessagingMethod {
  Future<String> sendNotification(
    String? fcmToken,
    String title,
    String text,
    UserModel user,
    String url,
  ) async {
    String res = "some error occur";
    String token = await AccessTokenFirebase().getAccessToken();
    if (fcmToken != null) {
      final response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/$firebaseProjectID/messages:send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "message": {
            "token": fcmToken,
            "notification": {
              "title": title,
              "body": text,
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "open_link": url,
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        res = "success";
      }
    }

    return res;
  }
}
