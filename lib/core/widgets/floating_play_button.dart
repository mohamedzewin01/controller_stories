import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'dart:math' as math;



class FloatingPlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final bool autoStart;
  final bool isLoading;
  final bool showRipple;
  final bool showPulse;
  final Duration? animationDuration;

  const FloatingPlayButton({
    super.key,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 60.0,
    this.autoStart = true,
    this.isLoading = false,
    this.showRipple = true,
    this.showPulse = true,
    this.animationDuration,
  });

  @override
  State<FloatingPlayButton> createState() => _FloatingPlayButtonState();
}

class _FloatingPlayButtonState extends State<FloatingPlayButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _glowController;
  late AnimationController _pressController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pressAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.autoStart) {
      _startAnimations();
    }
  }

  void _setupAnimations() {
    // Scale Animation - للظهور الأولي
    _scaleController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Rotation Animation - للدوران الخفيف
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    // Pulse Animation - للنبضة المستمرة
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Ripple Animation - للتأثير المتموج
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Glow Animation - للتوهج
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Press Animation - للضغط
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // إعداد الأنيميشن
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scaleController.forward();
        _glowController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _rotationController.repeat();
        if (widget.showPulse) {
          _pulseController.repeat(reverse: true);
        }
        if (widget.showRipple) {
          _rippleController.repeat();
        }
      }
    });
  }

  void _handleTap() {
    if (widget.isLoading) return;

    setState(() {
      _isPressed = true;
    });

    HapticFeedback.mediumImpact();

    // Press animation
    _pressController.forward().then((_) {
      _pressController.reverse();
    });

    // Ripple effect
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _glowController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleController,
        _rotationController,
        _pulseController,
        _rippleController,
        _glowController,
        _pressController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Transform.scale(
              scale: _pressAnimation.value,
              child: _buildButton(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    final primaryColor = widget.backgroundColor ?? ColorManager.primaryColor;
    final size = widget.size;

    return SizedBox(
      width: size * 2,
      height: size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple Effect
          if (widget.showRipple && _rippleAnimation.value > 0) ...[
            for (int i = 0; i < 3; i++)
              Transform.scale(
                scale: _rippleAnimation.value * (1 + i * 0.3),
                child: Container(
                  width: size * 1.5,
                  height: size * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(
                        (1 - _rippleAnimation.value) * 0.3 / (i + 1),
                      ),
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],

          // Glow Effect
          Container(
            width: size * 1.2,
            height: size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25 * _glowAnimation.value),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 4 * _glowAnimation.value,
                ),
                BoxShadow(
                  color: primaryColor.withOpacity(0.1 * _glowAnimation.value),
                  blurRadius: 35 * _glowAnimation.value,
                  spreadRadius: 6 * _glowAnimation.value,
                ),
              ],
            ),
          ),

          // Main Button
          GestureDetector(
            onTap: _handleTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.9),
                    primaryColor.withOpacity(0.7),
                    primaryColor.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: _buildIcon(),
              ),
            ),
          ),

          // Label (إذا كان موجود)
          if (widget.label != null)
            Positioned(
              bottom: -28,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.label!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: widget.size * 0.4,
          height: widget.size * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.foregroundColor ?? Colors.white,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Transform.rotate(
        angle: _rotationAnimation.value * 0.1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow للأيقونة
            Transform.translate(
              offset: const Offset(1, 1),
              child: Icon(
                Icons.play_arrow_rounded,
                size: widget.size * 0.5,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            // الأيقونة الأساسية
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 1.0 + (math.sin(value * math.pi * 4) * 0.04),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: widget.size * 0.5,
                    color: widget.foregroundColor ?? Colors.white,
                  ),
                );
              },
            ),
            // Highlight effect
            Positioned(
              top: widget.size * 0.2,
              left: widget.size * 0.2,
              child: Container(
                width: widget.size * 0.15,
                height: widget.size * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Widget مخصص للقصص مع تحسينات إضافية
// class StoryFloatingPlayButton extends StatelessWidget {
//   final int childId;
//   final int storyId;
//   final String? customLabel;
//   final VoidCallback? onPlayPressed;
//   final bool isLoading;
//   final double size;
//   final bool showFloatingLabel;
//
//   const StoryFloatingPlayButton({
//     super.key,
//     required this.childId,
//     required this.storyId,
//     this.customLabel,
//     this.onPlayPressed,
//     this.isLoading = false,
//     this.size = 60.0,
//     this.showFloatingLabel = true,
//   });
//
//   void _navigateToStoryPlay(BuildContext context) {
//     if (onPlayPressed != null) {
//       onPlayPressed!();
//       return;
//     }
//
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             StoriesPlayPage(
//               childId: childId,
//               storyId: storyId,
//             ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOutCubic,
//             )),
//             child: FadeTransition(
//               opacity: animation,
//               child: ScaleTransition(
//                 scale: Tween<double>(
//                   begin: 0.8,
//                   end: 1.0,
//                 ).animate(CurvedAnimation(
//                   parent: animation,
//                   curve: Curves.easeOutBack,
//                 )),
//                 child: child,
//               ),
//             ),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 600),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FloatingPlayButton(
//       onPressed: () => _navigateToStoryPlay(context),
//       label: showFloatingLabel ? (customLabel ?? 'تشغيل القصة') : null,
//       isLoading: isLoading,
//       size: size,
//       backgroundColor: ColorManager.primaryColor,
//       foregroundColor: Colors.white,
//     );
//   }
// }

// Widget متقدم مع المزيد من التحكم
class AdvancedFloatingPlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final bool isLoading;
  final List<Color>? gradientColors;
  final bool showParticles;
  final bool showWaveEffect;

  const AdvancedFloatingPlayButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 60.0,
    this.isLoading = false,
    this.gradientColors,
    this.showParticles = false,
    this.showWaveEffect = false,
  });

  @override
  State<AdvancedFloatingPlayButton> createState() => _AdvancedFloatingPlayButtonState();
}

class _AdvancedFloatingPlayButtonState extends State<AdvancedFloatingPlayButton>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.showParticles) {
      _particleController.repeat();
    }
    if (widget.showWaveEffect) {
      _waveController.repeat();
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Particle Effect
        if (widget.showParticles)
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return SizedBox(
                width: widget.size * 3,
                height: widget.size * 3,
                child: CustomPaint(
                  painter: ParticlePainter(
                    animation: _particleController,
                    color: widget.backgroundColor ?? ColorManager.primaryColor,
                  ),
                ),
              );
            },
          ),

        // Wave Effect
        if (widget.showWaveEffect)
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return SizedBox(
                width: widget.size * 2,
                height: widget.size * 2,
                child: CustomPaint(
                  painter: WavePainter(
                    animation: _waveController,
                    color: widget.backgroundColor ?? ColorManager.primaryColor,
                  ),
                ),
              );
            },
          ),

        // Main Button
        FloatingPlayButton(
          onPressed: widget.onPressed,
          label: widget.label,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          size: widget.size,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }
}

// Custom Painter للجسيمات
class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  ParticlePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) + (animation.value * math.pi * 2);
      final particleRadius = radius * (0.5 + 0.5 * math.sin(animation.value * math.pi * 2));
      final x = center.dx + math.cos(angle) * particleRadius;
      final y = center.dy + math.sin(angle) * particleRadius;

      canvas.drawCircle(
        Offset(x, y),
        3 * (1 - animation.value),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter للموجات
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * animation.value * (1 + i * 0.3);
      final opacity = (1 - animation.value) * (1 - i * 0.3);

      paint.color = color.withOpacity(opacity * 0.3);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// // صفحة الأمثلة
// class FloatingPlayButtonExample extends StatefulWidget {
//   const FloatingPlayButtonExample({super.key});
//
//   @override
//   State<FloatingPlayButtonExample> createState() => _FloatingPlayButtonExampleState();
// }
//
// class _FloatingPlayButtonExampleState extends State<FloatingPlayButtonExample> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Enhanced Floating Play Button'),
//         backgroundColor: ColorManager.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade50,
//               Colors.purple.shade50,
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // الزر الأساسي
//               FloatingPlayButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('تم تشغيل القصة!')),
//                   );
//                 },
//                 label: 'تشغيل القصة',
//                 size: 60,
//               ),
//
//               // زر مع تحميل
//               FloatingPlayButton(
//                 onPressed: () {
//                   setState(() {
//                     _isLoading = true;
//                   });
//                   Future.delayed(const Duration(seconds: 3), () {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   });
//                 },
//                 label: 'تحميل',
//                 isLoading: _isLoading,
//                 backgroundColor: Colors.green,
//                 size: 60,
//               ),
//
//               // زر متقدم مع تأثيرات
//               AdvancedFloatingPlayButton(
//                 onPressed: () {},
//                 label: 'تأثيرات خاصة',
//                 backgroundColor: Colors.purple,
//                 size: 60,
//                 showParticles: true,
//                 showWaveEffect: true,
//               ),
//
//               // زر القصة (الاستخدام الفعلي)
//               StoryFloatingPlayButton(
//                 childId: 1,
//                 storyId: 123,
//                 customLabel: 'ابدأ المغامرة',
//                 size: 60,
//                 onPlayPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('انتقال إلى صفحة القصة!')),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }