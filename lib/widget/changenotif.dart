import 'package:flutter/material.dart';

class Test with ChangeNotifier {
  bool _kok = false;

  bool get kok => _kok;

  void gokok() {
    _kok = !_kok;
    notifyListeners();
  }
}
