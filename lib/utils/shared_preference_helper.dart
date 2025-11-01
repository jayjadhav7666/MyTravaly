
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  SharedPreferenceHelper._privateConstructor();
  static final SharedPreferenceHelper instance =
      SharedPreferenceHelper._privateConstructor();

  Future<bool> setVisitorToken(String visitorToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('visitorToken', visitorToken);
  }

  Future<String> getVisitorToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('visitorToken') ?? "";
  }

  }