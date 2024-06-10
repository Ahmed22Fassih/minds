
import 'helper.dart';

class Prefs {
  static Future<void> clear() async {
    PreferencesHelper.clearPrefs();
  }


}