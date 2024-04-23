import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static late SharedPreferences _instance;

  static initialize() async {
    SharedPreferences.setPrefix('quran_random_ayah_taaaf11');
    _instance = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    return _instance;
  }
}
