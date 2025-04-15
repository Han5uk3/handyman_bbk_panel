import 'package:handyman_bbk_panel/main.dart';

class HiveHelper {
  static putUID(String uid) {
    return MyApp.box.put('uid', uid);
  }

  static getUID() {
    return MyApp.box.get('uid');
  }

  static removeUID() {
    return MyApp.box.delete('uid');
  }
}
