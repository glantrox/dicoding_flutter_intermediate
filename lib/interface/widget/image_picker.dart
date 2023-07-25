import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/file_provider.dart';

Widget showImage(BuildContext context) {
  final provider = context.read<FileProvider>();
  File path = File(provider.imagePath ?? "");
  return FittedBox(
      clipBehavior: Clip.hardEdge, fit: BoxFit.cover, child: Image.file(path));
}
