import 'package:flutter/material.dart';

class BodyPage extends ChangeNotifier {
  String pageSelected = "Home";

  void setPageSelect(String pageName) {
    pageSelected = pageName;
    notifyListeners();
  }

  // String get getPageSelectd => pageSelected;
}
