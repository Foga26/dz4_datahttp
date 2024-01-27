import 'package:flutter/material.dart';

class Test with ChangeNotifier {
  bool _kok = false;

  bool get kok => _kok;
  bool get chekboxValues => _chekboxValues;
  bool isExpanded = false;
  bool isTimerVisible = false;
  bool _chekboxValues = false;
  void chekBoxValuesState(index) {
    index = _chekboxValues;
    _chekboxValues = !_chekboxValues;
    notifyListeners();
  }

  void gokok() {
    _kok = !_kok;
    isExpanded = !isExpanded;
    isTimerVisible = !isTimerVisible;
    notifyListeners();
  }
}
