import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String _username = "";

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
