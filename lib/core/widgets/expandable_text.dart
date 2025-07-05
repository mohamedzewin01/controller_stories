import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({super.key, required this.description, required this.isRTL});
  final String description;
  final bool isRTL;
  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          maxLines: isExpanded ? null : 2,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: getRegularStyle(
            fontSize: 14,
            color: Colors.grey.shade700,

          ).copyWith(
            height: 1.6,


          ),
          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded
                ? (widget.isRTL ? 'عرض اقل' : 'Show Less')
                : (widget.isRTL ? 'عرض المزيد' : 'Show More'),
            style: TextStyle(
              fontSize: 14,
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}