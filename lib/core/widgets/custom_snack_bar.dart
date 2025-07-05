import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/resources/values_manager.dart';

class CustomSnackBar {
  static void showSuccessSnackBar(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: ColorManager.success,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showErrorSnackBar(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 4),
      }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: ColorManager.error,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showInfoSnackBar(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: ColorManager.primaryColor,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void showWarningSnackBar(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: ColorManager.warning,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  static void _showSnackBar(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        required IconData icon,
        required Duration duration,
      }) {
    // Remove any existing snackbar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: AppSize.s20,
            ),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Text(
                message,
                style: getMediumStyle(
                  color: Colors.white,
                  fontSize: AppSize.s14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        margin: const EdgeInsets.all(AppMargin.m16),
        elevation: 6,
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingWidget({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? AppSize.s20,
      height: size ?? AppSize.s20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}