import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';

import '../resources/values_manager.dart';

class CustomTextFormAuth extends StatelessWidget {
  const CustomTextFormAuth({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputType,
    this.validator,
    required this.title,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.prefixIcon,
    this.maxLines,
  });

  final TextEditingController controller;

  final String hintText;
  final String title;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;

  final TextInputType? textInputType;

  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty
            ? const SizedBox()
            : Text(
                title,
                style: getSemiBoldStyle(color: Colors.black54, fontSize: 14),
              ),
        SizedBox(height: 8),
        TextFormField(
          onTap: onTap,
          readOnly: readOnly ?? false,
          maxLines: maxLines ?? 1,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintStyle: getSemiBoldStyle(color: Colors.black38, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: ColorManager.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: ColorManager.inputBorder.withOpacity(0.7),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: ColorManager.chatUserBg.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
          ),

          keyboardType: textInputType,
          validator: validator,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputType,
    this.validator,

    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.prefixIcon,
    this.maxLines,
  });

  final TextEditingController controller;

  final String hintText;

  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;

  final TextInputType? textInputType;

  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: getSemiBoldStyle(color: ColorManager.primaryColor, fontSize: 14),
      onTap: onTap,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      controller: controller,

      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintStyle: getSemiBoldStyle(color: Colors.black38, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: ColorManager.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: ColorManager.inputBorder.withOpacity(0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: ColorManager.chatUserBg.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 12.0,
        ),
        filled: true,
        fillColor: Colors.white,
      ),

      keyboardType: textInputType,
      validator: validator,
    );
  }
}



class CustomTextFormNew extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormNew({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.validator,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextFormNew> createState() => _CustomTextFormNewState();
}

class _CustomTextFormNewState extends State<CustomTextFormNew> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: getMediumStyle(
              color: ColorManager.darkGrey,
              fontSize: AppSize.s14,
            ),
          ),
          const SizedBox(height: AppSize.s8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s12),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: ColorManager.primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            focusNode: _focusNode,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: getRegularStyle(
              color: widget.enabled ? ColorManager.darkGrey : ColorManager.grey,
              fontSize: AppSize.s14,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: getRegularStyle(
                color: ColorManager.grey,
                fontSize: AppSize.s14,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                widget.prefixIcon,
                color: _isFocused
                    ? ColorManager.primaryColor
                    : ColorManager.grey,
                size: AppSize.s20,
              )
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: widget.enabled
                  ? (_isFocused
                  ? ColorManager.primaryColor.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.05))
                  : Colors.grey.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: ColorManager.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: ColorManager.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: ColorManager.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p16,
                vertical: AppPadding.p14,
              ),
              counterText: '', // Hide character counter
              errorStyle: getRegularStyle(
                color: ColorManager.error,
                fontSize: AppSize.s12,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.s16),
      ],
    );
  }
}