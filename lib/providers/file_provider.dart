import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FileProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }
}
