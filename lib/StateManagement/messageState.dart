import 'package:flutter/material.dart';

class MessageState extends ChangeNotifier {
  int _totalUnseenMessage = 0;

  int get totalMessage => _totalUnseenMessage;

  void setTotalUnseenMessage(int unseenMessage) {
    _totalUnseenMessage = unseenMessage;
    notifyListeners();
  }
}
