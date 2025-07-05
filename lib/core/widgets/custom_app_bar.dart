// import 'package:flutter/material.dart';
//
// class CustomAppBar extends StatelessWidget {
//   const CustomAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.shade400,
//                   Colors.purple.shade400,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.auto_stories_rounded,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           Center(
//             child: const Text(
//               'Stories',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/l10n/app_localizations.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, this.onTapActionTow, this.onTapActionOne, this.iconActionTwo, this.iconActionOne, this.showBadge, });

  final VoidCallback? onTapActionTow;
  final VoidCallback? onTapActionOne;
  final IconData ? iconActionTwo;
  final IconData ? iconActionOne;
  final bool ? showBadge;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // إعداد أنيميشن اللمعان
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // بدء الأنيميشن
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              _buildStoryIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTitle(),
              ),
              const SizedBox(width: 16),

              _buildActionButtons(iconActionOne: widget.iconActionOne,iconActionTwo: widget.iconActionTwo ,showBadge: widget.showBadge?? false,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     const Color(0xFF667eea),
            //     const Color(0xFF764ba2).withOpacity(0.9),
            //     const Color(0xFF6B73FF),
            //   ],
            // ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.white.withOpacity(0.2),
              // color: const Color(0xFF764ba2).withOpacity(0.2),
              width: 1,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF764ba2)
            //         .withOpacity(0.1 + _pulseAnimation.value * 0.2),
            //     blurRadius: 10 + _pulseAnimation.value * 5,
            //     spreadRadius: _pulseAnimation.value * 2,
            //     offset: const Offset(0, 0),
            //   ),
            // ],
          ),
          child: const Center(
            child: Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 24,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // النص الأساسي
             Text(
              AppLocalizations.of(context)!.appName,
              style:


              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: ColorManager.primaryColor,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            // تأثير اللمعان
            ClipRect(
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                       ColorManager.white.withOpacity(0.2),
                       ColorManager.primaryColor.withOpacity(0.9),
                         ColorManager.white.withOpacity(0.9),
                          // Color(0xFF667eea),
                          // Color(0xFF764ba2).withOpacity(0.3),
                          // Color(0xFF6B73FF),
                        ],
                        stops: [
                          (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnimation.value.clamp(0.0, 1.0),
                          (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ).createShader(bounds);
                    },
                    child:  Text(
                      AppLocalizations.of(context)!.appName,
                      style:

                      TextStyle(
                        color: ColorManager.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons({IconData? iconActionOne,IconData? iconActionTwo ,bool showBadge = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        _buildActionButton(
          icon: iconActionTwo?? Icons.notifications_rounded,
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTapActionTow?.call();
          },
          showBadge:showBadge,
        ),

        const SizedBox(width: 12),


        _buildActionButton(
          icon: iconActionOne??Icons.search_rounded,
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTapActionOne?.call();
          },

        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.white.withOpacity(0.2),
            width: 1,
          ),
          shape: BoxShape.circle,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     // ColorManager.titleColor.withOpacity(0.7),
          //     // ColorManager.titleColor.withOpacity(0.6),
          //     // ColorManager.titleColor.withOpacity(0.7),
          //     // const Color(0xFF667eea),
          //     // const Color(0xFF764ba2),
          //     // const Color(0xFF6B73FF),
          //   ],
          //   stops: const [0.0, 0.5, 1.0],
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),

        child: Stack(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            if (showBadge)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    super.key, this.onTapActionTow, this.onTapActionOne, this.iconActionTwo, this.iconActionOne, this.showBadge,

  });

  final VoidCallback? onTapActionTow;
  final VoidCallback? onTapActionOne;
  final IconData ? iconActionTwo;
  final IconData ? iconActionOne;
  final bool ? showBadge;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
       expandedHeight: 60,
      centerTitle: true,
      floating: true,
      pinned: true,
      elevation: 3,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:  [
               ColorManager.primaryColor,
               ColorManager.primaryColor.withOpacity(0.9),
               ColorManager.primaryColor,

              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),

          child: SafeArea(
            child: CustomAppBar(
              onTapActionTow: onTapActionOne,
              onTapActionOne: onTapActionTow,
              iconActionOne: iconActionOne,
              iconActionTwo: iconActionTwo,
              showBadge: showBadge,
            ),
          ),
        ),
      ),
    );
  }
}