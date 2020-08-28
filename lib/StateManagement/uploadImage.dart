import 'dart:io';

import 'package:flutter/material.dart';

class UploadImage extends ChangeNotifier {
  File imageFile;

  setImage(File image) {
    imageFile = image;
    notifyListeners();
  }

  // String get getPageSelectd => pageSelected;
}
