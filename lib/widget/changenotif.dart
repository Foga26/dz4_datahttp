import 'package:flutter/material.dart';

class Test with ChangeNotifier {
  bool _kok = false;

  bool get kok => _kok;
  bool isExpanded = false;
  bool isTimerVisible = false;

  void gokok() {
    _kok = !_kok;
    isExpanded = !isExpanded;
    isTimerVisible = !isTimerVisible;
    notifyListeners();
  }
}
