import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/file_provider.dart';

onGalleryView(BuildContext context) async {
  final provider = context.read<FileProvider>();

  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  );
  if (pickedFile != null) {
    provider.setImageFile(pickedFile);
    provider.setImagePath(pickedFile.path);
  }
}
