import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;

  static const _searchPostHistory = 'searchPostHistory';
  static const _fcmToken = 'fcmToken';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Search Post History
  static Future setSearchPostHistory(String searchPostHistory) async {
    debugPrint('存：$searchPostHistory');
    List<String> list = _preferences?.getStringList(_searchPostHistory) ?? [];
    if (list.length < 20) {
      list.insert(0, searchPostHistory);
    } else if (list.length == 20) {
      list.removeLast();
      list.insert(0, searchPostHistory);
    }
    await _preferences?.setStringList(_searchPostHistory, list);
  }

  static Future removeSearchPostHistory(int index) async {
    List<String> list = _preferences?.getStringList(_searchPostHistory) ?? [];
    list.removeAt(index);
    await _preferences?.setStringList(_searchPostHistory, list);
  }

  static List<String>? getSearchPostHistory() =>
      _preferences?.getStringList(_searchPostHistory);

  //UserFCMToken
  static Future setFcmToken(String token) async {
    await _preferences?.setString(_fcmToken, token);
    debugPrint('fcmToken已儲存進手機，token是: $token');
  }

  static String? getFcmToken() => _preferences?.getString(_fcmToken);
}
