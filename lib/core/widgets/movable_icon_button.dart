import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class MovableIcon extends StatefulWidget {
  final VoidCallback onTap;

  const MovableIcon({super.key, required this.onTap});

  @override
  State<MovableIcon> createState() => _MovableIconState();
}

class _MovableIconState extends State<MovableIcon>
    with TickerProviderStateMixin {
  Offset? position;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final iconSize = 60.0;
  final bottomNavBarHeight = 55.0;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );


    _startShakeLoop();
  }

  void _startShakeLoop() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _shakeController.forward(from: 0).then((_) => _shakeController.reverse());
        _startShakeLoop();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (position == null) {
      final screenSize = MediaQuery.of(context).size;

      position = Offset(
        screenSize.width - iconSize - 20,
        screenSize.height - bottomNavBarHeight - iconSize - 20,
      );
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _updatePosition(DragUpdateDetails details) {
    final screenSize = MediaQuery.of(context).size;

    setState(() {
      double newX = position!.dx + details.delta.dx;
      double newY = position!.dy + details.delta.dy;

      double maxX = screenSize.width - iconSize;
      double maxY = screenSize.height - bottomNavBarHeight - iconSize;

      if (newX < 0) newX = 0;
      if (newX > maxX) newX = maxX;
      if (newY < 0) newY = 0;
      if (newY > maxY - 20) newY = maxY - 20;

      position = Offset(newX, newY);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) return const SizedBox();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: position!.dx,
      top: position!.dy,
      child: GestureDetector(
        onPanUpdate: _updatePosition,
        onTap: () {
          widget.onTap();
          _shakeController.forward(from: 0);
        },
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(
                'https://artawiya.com//DigitalArtawiya/image.jpeg',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
