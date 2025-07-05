


import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';

class FeatureRow extends StatelessWidget {
  const FeatureRow({super.key, required this.circleBgColor, required this.iconColor, required this.text});
  final Color circleBgColor;
  final Color iconColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: circleBgColor,
          child: Icon(Icons.check, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: getSemiBoldStyle(
              color: ColorManager.textColors,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}
