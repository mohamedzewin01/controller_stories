import 'package:flutter/material.dart';
import 'package:controller_stories/core/functions/permission_service.dart';
import 'package:controller_stories/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import '../resources/color_manager.dart';
import '../resources/style_manager.dart';

class CustomDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  "Loading...",
                  style: getBoldStyle(color: ColorManager.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are You Sure To Close The Application?",
                  textAlign: TextAlign.center,
                  style: getBoldStyle(color: ColorManager.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // زر NO
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(
                            color: ColorManager.primaryColor, width: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "NO",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    // زر YES
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, {Widget? goto}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.of(context).pop();
            if (goto != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => goto,
                  ));
            }
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 70,
                ),
                const SizedBox(height: 10),
                Text(
                  "Registration Successful!",
                  style: getBoldStyle(color: ColorManager.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: ColorManager.primaryColor,
                  size: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  "An Error Occurred!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message ?? "Something went wrong. Please try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Back",
                        style: getBoldStyle(
                            color: ColorManager.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showIncompleteDataDialog(BuildContext context,
      {void Function()? onPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: ColorManager.primaryColor,
                  size: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Incomplete Data!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please complete all required fields before proceeding.",
                  textAlign: TextAlign.center,
                  style: getBoldStyle(color: ColorManager.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Complete Data",
                        style: getBoldStyle(
                            color: ColorManager.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // Future<bool> isPermissionStorageGranted() async {
  //   final status = await Permission.photos.request(); // iOS
  //   final storageStatus = await Permission.storage.request(); // Android
  //
  //   if (status.isGranted || storageStatus.isGranted) {
  //     return true;
  //   }
  //
  //   if (status.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
  //     await openAppSettings(); // يفتح إعدادات التطبيق للمستخدم
  //   }
  //
  //   return false;
  // }

  // Future<bool> isPermissionCameraGranted() async {
  //   final status = await Permission.camera.request();
  //
  //   if (status.isGranted) {
  //     return true;
  //   }
  //
  //   if (status.isPermanentlyDenied) {
  //     await openAppSettings();
  //   }
  //
  //   return false;
  // }

  static Future<dynamic> showDialogAddImage(
      BuildContext context, {
        required Function gallery,
        required Function camera,
      }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: ColorManager.primaryColor.withAlpha(250),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
           AppLocalizations.of(context)!.chooseImageSource,
            textAlign: TextAlign.center,
            style:getBoldStyle(color: ColorManager.white, fontSize: 16),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildOption(
                icon: Icons.photo_library,
                label: AppLocalizations.of(context)!.gallery,
                onTap: () async {
                  var permission = await isPermissionStorageGranted();
                  if (permission == false) return;
                 await gallery();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _buildOption(
                icon: Icons.camera_alt,
                label:  AppLocalizations.of(context)!.camera,
                onTap: () async {
                  var permission = await isPermissionCameraGranted();
                  if (permission == false) return;
                  await camera();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  static Widget _buildOption(
      {required IconData icon, required String label, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 35, color: ColorManager.white),
          SizedBox(height: 8),
          Text(label, style:getBoldStyle(color: ColorManager.white, fontSize: 14)),
        ],
      ),
    );
  }
}
