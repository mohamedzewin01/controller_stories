import 'package:flutter/material.dart';

import '../resources/color_manager.dart';
import '../resources/style_manager.dart';


class AnimatedArrowButton extends StatefulWidget {
  const AnimatedArrowButton({super.key, required this.title, this.onTap, this.color});
final String title;
final  void Function()? onTap;
final  Color? color;

  @override
  State<AnimatedArrowButton> createState() => _AnimatedArrowButtonState();
}

class _AnimatedArrowButtonState extends State<AnimatedArrowButton> {
  int arrowCount = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, animateArrows);
  }

  void animateArrows() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        arrowCount = (arrowCount % 3) + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:widget.color ?? ColorManager.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed:widget.onTap ,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 40),
          Text(
          widget.title ,
            style: getSemiBoldStyle(
              color: Colors.white,
              fontSize: 20,
            ).copyWith(fontWeight: FontWeight.w900),
          ),


          SizedBox(
            width: 100,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Row(
                key: ValueKey<int>(arrowCount),
                children: List.generate(
                  arrowCount,
                      (index) => const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
