import 'package:googleapis_auth/auth_io.dart';

import '../secret.dart';

class AccessTokenFirebase {
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(firebase_admin_key_json),
      [firebaseMessagingScope],
    );

    final accessToken = client.credentials.accessToken.data;

    return accessToken;
  }
}
