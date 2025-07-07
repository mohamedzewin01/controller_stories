import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

PermissionStatus? permissionStorageStatus;
PermissionStatus? permissionCameraStatus;
PermissionStatus? permissionNotificationStatus;



Future<bool> isPermissionStorageGranted() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    // Android 13 (SDK 33) and above use separate permissions
    if (androidInfo.version.sdkInt >= 33) {
      final photosStatus = await Permission.photos.status;
      final videosStatus = await Permission.videos.status;

      // Check permanently denied
      if (photosStatus.isPermanentlyDenied || videosStatus.isPermanentlyDenied) {
        // Optional: Show dialog asking user to open settings
        await openAppSettings();
        return false;
      }

      // Request if not granted
      if (!photosStatus.isGranted || !videosStatus.isGranted) {
        final photosRequest = await Permission.photos.request();
        final videosRequest = await Permission.videos.request();
        return photosRequest.isGranted && videosRequest.isGranted;
      }

      return true;
    } else {
      // For Android 12 and below: storage permission
      final storageStatus = await Permission.storage.status;

      if (storageStatus.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      if (!storageStatus.isGranted) {
        final request = await Permission.storage.request();
        return request.isGranted;
      }

      return true;
    }
  } else {
    // iOS or other platforms
    return true;
  }
}




Future<bool> isPermissionCameraGranted() async {
  final cameraStatus = await Permission.camera.status;

  // الحالة المرفوضة نهائيًا
  if (cameraStatus.isPermanentlyDenied) {
    // يمكنك هنا عرض حوار يطلب من المستخدم الذهاب للإعدادات
    await openAppSettings();
    return false;
  }

  // إذا لم تكن الصلاحية ممنوحة
  if (!cameraStatus.isGranted) {
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  // الحالة الطبيعية
  return true;
}
