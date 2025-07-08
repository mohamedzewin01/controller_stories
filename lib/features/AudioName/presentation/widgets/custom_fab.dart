import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'إضافة',
  });

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                widget.onPressed();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              tooltip: widget.tooltip,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}