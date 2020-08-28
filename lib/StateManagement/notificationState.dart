import 'package:flutter/material.dart';

class NotificationState extends ChangeNotifier {
  int postNot = 0;
  int followerNot = 0;
  int articleNot = 0;

  int get totalNotification => postNot + followerNot + articleNot;

  void setNotificationInfo(int _postNot, int _followerNot, int _articleNot) {
    postNot = _postNot;
    followerNot = _followerNot;
    articleNot = _articleNot;
    notifyListeners();
  }

  void decrePostNot() {
    if (postNot > 0) {
      postNot--;
      notifyListeners();
    }
  }

  void decreFollowerNot() {
    if (followerNot > 0) {
      followerNot--;
      notifyListeners();
    }
  }

  void decreArticleNot() {
    if (articleNot > 0) {
      articleNot--;
      notifyListeners();
    }
  }
}
