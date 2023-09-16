import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FileProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  // O=========================================================================>
  // ? Set Image Path
  // <=========================================================================O

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  // O=========================================================================>
  // ? Set Image File
  // <=========================================================================O

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }
}
