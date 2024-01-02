import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;

  static const _searchPostHistory = 'searchPostHistory';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Search Post History
  static Future setSearchPostHistory(String searchPostHistory) async {
    print('存：$searchPostHistory');
    List<String> list = _preferences?.getStringList(_searchPostHistory) ?? [];
    if (list.length < 20) {
      list.insert(0, searchPostHistory);
    } else if (list.length == 20) {
      list.removeLast();
      list.insert(0, searchPostHistory);
    }
    await _preferences?.setStringList(_searchPostHistory, list);
  }

  static Future removeSearchPostHistory(int index)async{
    List<String> list = _preferences?.getStringList(_searchPostHistory) ?? [];
    list.removeAt(index);
    await _preferences?.setStringList(_searchPostHistory, list);
  }

  static List<String>? getSearchPostHistory() =>
      _preferences?.getStringList(_searchPostHistory);
}
