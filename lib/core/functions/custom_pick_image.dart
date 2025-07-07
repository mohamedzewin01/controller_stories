import 'package:controller_stories/core/widgets/custom_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImageDialog(BuildContext context) async {
  final picker = ImagePicker();

  File? result;

  await CustomDialog.showDialogAddImage(
    context,
    gallery: () async {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        result = File(pickedFile.path);
      }
    },
    camera: () async {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        result = File(pickedFile.path);
      }
    },
  );

  return result;
}



Future<File?> pickAudioFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
  } catch (e) {
    // يمكن عرض رسالة خطأ حسب الحاجة
    debugPrint('خطأ في اختيار الملف الصوتي: $e');
  }

  return null;
}
