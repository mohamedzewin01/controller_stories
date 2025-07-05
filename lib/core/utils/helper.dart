import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' ;


import '../resources/color_manager.dart';
import '../resources/values_manager.dart';

Widget passwordHidden({
  required bool isPasswordHidden,
  required void Function()? onPressed,
}) {
  return IconButton(
    icon: Icon(
      isPasswordHidden ? Icons.visibility_off : Icons.visibility,
    ),
    onPressed: onPressed,
  );
}

Widget buildIcon(String assetPath, int index, int currentIndex) {
  bool isSelected = index == currentIndex;

  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20, vertical: AppPadding.p4),
    decoration: BoxDecoration(
      color: isSelected
          ? ColorManager.primaryColor.withAlpha(100)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? ColorManager.primaryColor : ColorManager.textSecondary,
        BlendMode.srcIn,
      ),
    ),
  );
}


