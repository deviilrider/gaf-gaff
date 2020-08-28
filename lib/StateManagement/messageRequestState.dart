import 'package:flutter/material.dart';

class MessageRequestState extends ChangeNotifier{
  int _totalMessageRequest = 0;

  int get totalMessageRequest => _totalMessageRequest;

  void setTotalMessageRequest(){
    _totalMessageRequest++;
    notifyListeners();
  }

  void setTotalMessageRequestValue(int value){
    _totalMessageRequest = value;
    notifyListeners();
  }

  void decreaseTotalMessageRequest(){
    _totalMessageRequest--;
    notifyListeners();
  }

  void clearTotalMessageRequest(){
    _totalMessageRequest = 0;
    notifyListeners();
  }
}