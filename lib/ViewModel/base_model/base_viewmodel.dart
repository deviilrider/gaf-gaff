import 'package:flutter/material.dart';

class BaseModel with ChangeNotifier {
  bool busy = false;

  changeBusy(bool value) {
    busy = value;
    notifyListeners();
  }
}
