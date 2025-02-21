import 'package:anti_procastination/storage/model/local_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  setSignInInfo(String uuid, String name, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', <String>[uuid, name, email]);
  }

  Future<LocalUserModel?> getSignInInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? infos = prefs.getStringList('user');
    if (infos != null) {
      return LocalUserModel(name: infos[1], email: infos[2], uuid: infos[0]);
    }
    return null;
  }

  deleteSignInInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
