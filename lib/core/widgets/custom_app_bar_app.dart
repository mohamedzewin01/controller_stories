//
//
//
// import 'package:controller_stories/assets_manager.dart';
// import 'package:controller_stories/core/resources/style_manager.dart';
// import 'package:flutter/material.dart';
//
// import '../resources/color_manager.dart';
//
// class CustomAppBarApp extends StatefulWidget {
//   const CustomAppBarApp({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     this.backFunction,
//     this.colorContainerStack,
//   });
//
//   final String title;
//   final String subtitle;
//   final void Function()? backFunction;
//   final Color? colorContainerStack;
//
//   @override
//   State<CustomAppBarApp> createState() => _CustomAppBarAppState();
// }
//
// class _CustomAppBarAppState extends State<CustomAppBarApp>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     _fadeController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 20,
//             right: 20,
//             bottom: 15,
//           ),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 ColorManager.primaryColor.withOpacity(0.6),
//
//                 ColorManager.primaryColor.withOpacity(0.3),
//                 ColorManager.primaryColor.withOpacity(0.1),
//                 // Colors.transparent,      // Colors.transparent,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Row(
//             children: [
//               // زر الرجوع
//               Container(
//                 decoration: BoxDecoration(
//                   color: ColorManager.primaryColor.withOpacity(0.1),
//                   image: DecorationImage(image: AssetImage(Assets.logoRemovebgPng),fit: BoxFit.cover),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.transparent,
//                   ),
//                   onPressed: () {
//                     if (widget.backFunction != null) {
//                       widget.backFunction!();
//                     } else {
//                       LayoutCubit.get(context).changeIndex(0);
//                     }
//                   },
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//
//               Expanded(
//                 child: FadeTransition(
//                   opacity: _fadeController,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.title,
//                         style: getBoldStyle(
//                           color: ColorManager.primaryColor,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         widget.subtitle,
//                         style: getRegularStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // أيقونة إضافية
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorManager.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.auto_stories_rounded,
//                   color: ColorManager.primaryColor,
//                   size: 24,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             decoration: BoxDecoration(
//               color: widget.colorContainerStack ?? Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(50),
//                 topRight: Radius.circular(50),
//               ),
//             ),
//             width: double.infinity,
//             height: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CustomSliverAppBarApp extends StatefulWidget {
//   const CustomSliverAppBarApp({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     this.backFunction,
//     this.colorContainerStack,
//     this.expandedHeight = 120.0,
//     this.floating = true,
//     this.pinned = true,
//     this.snap = false,
//     this.elevation = 0,
//     this.leadingIcon,
//     this.trailingIcon,
//     this.onTrailingPressed,
//     this.showCurvedBottom = true,
//   });
//
//   final String title;
//   final String subtitle;
//   final void Function()? backFunction;
//   final Color? colorContainerStack;
//   final double expandedHeight;
//   final bool floating;
//   final bool pinned;
//   final bool snap;
//   final double elevation;
//   final IconData? leadingIcon;
//   final IconData? trailingIcon;
//   final VoidCallback? onTrailingPressed;
//   final bool showCurvedBottom;
//
//   @override
//   State<CustomSliverAppBarApp> createState() => _CustomSliverAppBarAppState();
// }
//
// class _CustomSliverAppBarAppState extends State<CustomSliverAppBarApp>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _fadeController.forward();
//     _scaleController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: widget.expandedHeight,
//       floating: widget.floating,
//       pinned: widget.pinned,
//       snap: widget.snap,
//       elevation: widget.elevation,
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       flexibleSpace: FlexibleSpaceBar(
//         background: _buildAppBarBackground(),
//         collapseMode: CollapseMode.parallax,
//       ),
//     );
//   }
//
//   Widget _buildAppBarBackground() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // حساب نسبة الانكماش
//         final double shrinkPercentage =
//             constraints.maxHeight <= kToolbarHeight + 20
//             ? 1.0
//             : (widget.expandedHeight - constraints.maxHeight) /
//                   (widget.expandedHeight - kToolbarHeight);
//
//         return AnimatedBuilder(
//           animation: _fadeController,
//           builder: (context, child) {
//             return Stack(
//               children: [
//                 // الخلفية المتدرجة
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorManager.primaryColor.withOpacity(
//                           0.6 * (1 - shrinkPercentage * 0.3),
//                         ),
//                         ColorManager.primaryColor.withOpacity(
//                           0.3 * (1 - shrinkPercentage * 0.5),
//                         ),
//                         ColorManager.primaryColor.withOpacity(
//                           0.1 * (1 - shrinkPercentage * 0.7),
//                         ),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//
//                 // المحتوى الرئيسي
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top + 10,
//                   left: 20,
//                   right: 20,
//                   child: _buildAppBarContent(shrinkPercentage),
//                 ),
//
//                 // الجزء المنحني السفلي
//                 if (widget.showCurvedBottom)
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: _buildCurvedBottom(shrinkPercentage),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildAppBarContent(double shrinkPercentage) {
//     return FadeTransition(
//       opacity: _fadeController,
//       child: ScaleTransition(
//         scale: Tween<double>(begin: 0.9, end: 1.0).animate(_scaleController),
//         child: Row(
//           children: [
//             // زر الرجوع
//             _buildBackButton(shrinkPercentage),
//
//             const SizedBox(width: 16),
//
//             // النصوص
//             Expanded(child: _buildTitleSection(shrinkPercentage)),
//
//             // الأيقونة الجانبية
//             _buildTrailingIcon(shrinkPercentage),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBackButton(double shrinkPercentage) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween(begin: 0.0, end: shrinkPercentage),
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: 1.0 - (value * 0.1),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(1.0 - (value * 0.3)),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1 * (1 - value * 0.5)),
//                   blurRadius: 10 * (1 - value * 0.5),
//                   offset: Offset(0, 2 * (1 - value * 0.5)),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: Icon(
//                 widget.leadingIcon ?? Icons.arrow_back_ios_rounded,
//                 color: ColorManager.primaryColor,
//                 size: 20,
//               ),
//               onPressed: () {
//                 if (widget.backFunction != null) {
//                   widget.backFunction!();
//                 } else {
//                   LayoutCubit.get(context).changeIndex(0);
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleSection(double shrinkPercentage) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween(begin: 0.0, end: shrinkPercentage),
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: 1.0 - (value * 0.3),
//           child: Transform.translate(
//             offset: Offset(0, value * -5),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   widget.title,
//                   style: getBoldStyle(
//                     color: ColorManager.primaryColor,
//                     fontSize: (16 + (1 - value) * 2).clamp(14.0, 18.0),
//                   ),
//                 ),
//                 if (widget.subtitle.isNotEmpty && value < 0.7) ...[
//                   const SizedBox(height: 4),
//                   Opacity(
//                     opacity: (1 - value * 1.5).clamp(0.0, 1.0),
//                     child: Text(
//                       widget.subtitle,
//                       style: getRegularStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTrailingIcon(double shrinkPercentage) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween(begin: 0.0, end: shrinkPercentage),
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: 1.0 - (value * 0.15),
//           child: GestureDetector(
//             onTap: widget.onTrailingPressed,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: ColorManager.primaryColor.withOpacity(
//                   0.1 * (1 - value * 0.5),
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: ColorManager.primaryColor.withOpacity(
//                     0.2 * (1 - value * 0.3),
//                   ),
//                   width: 1,
//                 ),
//               ),
//               child: Icon(
//                 widget.trailingIcon ?? Icons.auto_stories_rounded,
//                 color: ColorManager.primaryColor,
//                 size: 24,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCurvedBottom(double shrinkPercentage) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween(begin: 0.0, end: shrinkPercentage),
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: (1 - value * 1.2).clamp(0.0, 1.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: widget.colorContainerStack ?? Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(50 * (1 - value * 0.5)),
//                 topRight: Radius.circular(50 * (1 - value * 0.5)),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05 * (1 - value)),
//                   blurRadius: 10 * (1 - value),
//                   offset: Offset(0, -2 * (1 - value)),
//                 ),
//               ],
//             ),
//             width: double.infinity,
//             height: (10 + (1 - value) * 5).clamp(5.0, 15.0),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // نسخة مبسطة للاستخدام السريع
// class SimpleSliverAppBar extends StatelessWidget {
//   const SimpleSliverAppBar({
//     super.key,
//     required this.title,
//     this.subtitle = '',
//     this.onBackPressed,
//     this.onActionPressed,
//     this.actionIcon,
//     this.backgroundColor,
//   });
//
//   final String title;
//   final String subtitle;
//   final VoidCallback? onBackPressed;
//   final VoidCallback? onActionPressed;
//   final IconData? actionIcon;
//   final Color? backgroundColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomSliverAppBarApp(
//       title: title,
//       subtitle: subtitle,
//       backFunction: onBackPressed,
//       onTrailingPressed: onActionPressed,
//       trailingIcon: actionIcon,
//       colorContainerStack: backgroundColor,
//       expandedHeight: 100,
//       floating: true,
//       pinned: true,
//     );
//   }
// }
//
// // نسخة متقدمة مع تأثيرات إضافية
// class AdvancedSliverAppBar extends StatefulWidget {
//   const AdvancedSliverAppBar({
//     super.key,
//     required this.title,
//     this.subtitle = '',
//     this.backgroundImage,
//     this.actions = const [],
//     this.onBackPressed,
//     this.showSearch = false,
//     this.onSearchPressed,
//   });
//
//   final String title;
//   final String subtitle;
//   final String? backgroundImage;
//   final List<Widget> actions;
//   final VoidCallback? onBackPressed;
//   final bool showSearch;
//   final VoidCallback? onSearchPressed;
//
//   @override
//   State<AdvancedSliverAppBar> createState() => _AdvancedSliverAppBarState();
// }
//
// class _AdvancedSliverAppBarState extends State<AdvancedSliverAppBar>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 160,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       flexibleSpace: FlexibleSpaceBar(
//         background: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Stack(
//               children: [
//                 // خلفية مع صورة اختيارية
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorManager.primaryColor.withOpacity(0.8),
//                         ColorManager.primaryColor.withOpacity(0.4),
//                         Colors.transparent,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   child: widget.backgroundImage != null
//                       ? Opacity(
//                           opacity: 0.3,
//                           child: Image.asset(
//                             widget.backgroundImage!,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : null,
//                 ),
//
//                 // المحتوى
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top + 10,
//                   left: 20,
//                   right: 20,
//                   child: FadeTransition(
//                     opacity: _animation,
//                     child: Row(
//                       children: [
//                         // زر الرجوع
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.arrow_back_ios_rounded,
//                               color: ColorManager.primaryColor,
//                             ),
//                             onPressed:
//                                 widget.onBackPressed ??
//                                 () => LayoutCubit.get(context).changeIndex(0),
//                           ),
//                         ),
//
//                         const SizedBox(width: 16),
//
//                         // العنوان
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.title,
//                                 style: getBoldStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               if (widget.subtitle.isNotEmpty) ...[
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   widget.subtitle,
//                                   style: getRegularStyle(
//                                     color: Colors.white.withOpacity(0.8),
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//
//                         // الإجراءات
//                         ...widget.actions,
//
//                         if (widget.showSearch)
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.search_rounded,
//                                 color: Colors.white,
//                               ),
//                               onPressed: widget.onSearchPressed,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // الجزء المنحني
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: SlideTransition(
//                     position: Tween<Offset>(
//                       begin: const Offset(0, 1),
//                       end: Offset.zero,
//                     ).animate(_animation),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           topRight: Radius.circular(30),
//                         ),
//                       ),
//                       height: 15,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
