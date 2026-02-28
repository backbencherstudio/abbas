import 'package:flutter/material.dart';

class ButtonProvider extends ChangeNotifier {
  Color _backgroundColor = const Color(0xFF0A1A29);
  Color _textColor = const Color(0xFF3D4566);

  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  void load() {
    if (_backgroundColor == const Color(0xFF0A1A29)) {
      _backgroundColor = Colors.green;
      _textColor = Colors.white;
    } else {
      _backgroundColor = const Color(0xFF0A1A29);
      _textColor = const Color(0xFF3D4566);
    }
    notifyListeners();
  }
}
