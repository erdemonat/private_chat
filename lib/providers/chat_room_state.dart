import 'package:flutter/material.dart';

class ChatRoomState extends ChangeNotifier {
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  set isOnline(bool value) {
    if (_isOnline != value) {
      _isOnline = value;
      notifyListeners();
    }
  }
}
