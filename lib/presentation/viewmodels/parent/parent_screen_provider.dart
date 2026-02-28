import 'package:flutter/foundation.dart';

class ParentViewModel extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void setIndex(int i) { if (i != _index) { _index = i; notifyListeners(); } }
}
