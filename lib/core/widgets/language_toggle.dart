
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:controller_stories/localization/locale_cubit.dart';
import 'dart:ui';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _morphController;
  late AnimationController _glowController;
  late AnimationController _rotationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _morphAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _widthAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Main interaction controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Morphing/expansion controller
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Glow effect controller
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Rotation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Scale for tap feedback
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    // Morphing animation
    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeInOutCubic,
    ));

    // Width expansion - حجم محسوب بدقة لتجنب overflow
    _widthAnimation = Tween<double>(
      begin: 60.0,
      end: 160.0, // زيادة العرض لتجنب overflow
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeOutBack,
    ));

    // Glow animation
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));

    // Start continuous animations
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _morphController.dispose();
    _glowController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _morphController.forward();
    } else {
      _morphController.reverse();
    }
  }

  void _changeLanguage(String languageCode) {
    final localeCubit = context.read<LocaleCubit>();
    final currentLang = localeCubit.state.languageCode;

    if (languageCode != currentLang) {
      localeCubit.changeLanguage(languageCode);

      // Trigger rotation animation
      _rotationController.reset();
      _rotationController.forward();
    }

    // Close expansion with improved timing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isExpanded = false;
        });
        _morphController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _mainController,
              _morphController,
              _glowController,
              _rotationController,
            ]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: _buildMainWidget(locale),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMainWidget(Locale locale) {
    return GestureDetector(
      onTapDown: (_) => _mainController.forward(),
      onTapUp: (_) {
        _mainController.reverse();
        _toggleExpansion();
      },
      onTapCancel: () => _mainController.reverse(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        width: _widthAnimation.value,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2 * _glowAnimation.value),
              blurRadius: 25 * _glowAnimation.value,
              spreadRadius: 3 * _glowAnimation.value,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16), // تقليل padding لحل overflow
              child: _isExpanded
                  ? _buildExpandedContent(locale)
                  : _buildCollapsedContent(locale),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent(Locale locale) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle with glow effect
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Rotated flag
          Transform.rotate(
            angle: _rotationAnimation.value * 6.28,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  locale.languageCode == 'ar' ? '🇸🇦' : '🇺🇸',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          // Pulse ring effect
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 45 + (_glowAnimation.value * 5),
                height: 45 + (_glowAnimation.value * 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3 * (1 - _glowAnimation.value)),
                    width: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Locale locale) {
    return Row(

      children: [
        // Current language indicator
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              locale.languageCode == 'ar' ? '🇸🇦' : '🇺🇸',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),

        // Divider line
        Container(
          width: 1,
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Language toggle buttons
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickToggle('🇺🇸', 'en', locale.languageCode == 'en'),
              _buildQuickToggle('🇸🇦', 'ar', locale.languageCode == 'ar'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickToggle(String flag, String code, bool isSelected) {
    return GestureDetector(
      onTap: () => _changeLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.7)
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: isSelected ? 14 : 12,
            ),
            child: Text(flag),
          ),
        ),
      ),
    );
  }
}