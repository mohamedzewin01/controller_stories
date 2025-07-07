// // import 'package:flutter/material.dart';
// // import 'package:controller_stories/core/resources/color_manager.dart';
// // import 'package:controller_stories/core/resources/style_manager.dart';
// // import 'package:controller_stories/core/resources/cashed_image.dart';
// // import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
// //
// // class StoryCard extends StatelessWidget {
// //   final Stories story;
// //   final int index;
// //   final VoidCallback? onTap;
// //   final VoidCallback? onEdit;
// //   final VoidCallback? onDelete;
// //   final VoidCallback? onViewDetails;
// //
// //   const StoryCard({
// //     super.key,
// //     required this.story,
// //     required this.index,
// //     this.onTap,
// //     this.onEdit,
// //     this.onDelete,
// //     this.onViewDetails,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TweenAnimationBuilder<double>(
// //       duration: Duration(milliseconds: 600 + (index * 100)),
// //       tween: Tween(begin: 0.0, end: 1.0),
// //       builder: (context, value, child) {
// //         return Transform.scale(
// //           scale: value,
// //           child: Container(
// //             margin: const EdgeInsets.only(bottom: 16),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.08),
// //                   blurRadius: 15,
// //                   offset: const Offset(0, 8),
// //                 ),
// //               ],
// //             ),
// //             child: Material(
// //               color: Colors.transparent,
// //               child: InkWell(
// //                 borderRadius: BorderRadius.circular(20),
// //                 onTap: onTap,
// //                 child: Column(
// //                   children: [
// //                     // Header with image and basic info
// //                     _buildHeader(),
// //
// //                     // Content section
// //                     _buildContent(),
// //
// //                     // Footer with tags and actions
// //                     _buildFooter(context),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Container(
// //       height: 120,
// //       decoration: BoxDecoration(
// //         borderRadius: const BorderRadius.only(
// //           topLeft: Radius.circular(20),
// //           topRight: Radius.circular(20),
// //         ),
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [
// //             getGenderColor(story.gender ?? 'Boy').withOpacity(0.1),
// //             getGenderColor(story.gender ?? 'Boy').withOpacity(0.05),
// //           ],
// //         ),
// //       ),
// //       child: Stack(
// //         children: [
// //           // Background pattern
// //           Positioned.fill(
// //             child: CustomPaint(
// //               painter: PatternPainter(
// //                 color: getGenderColor(story.gender ?? 'Boy').withOpacity(0.03),
// //               ),
// //             ),
// //           ),
// //
// //           // Content
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Row(
// //               children: [
// //                 // Story Image
// //                 Hero(
// //                   tag: 'story_image_${story.storyId}',
// //                   child: Container(
// //                     width: 80,
// //                     height: 80,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(16),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.1),
// //                           blurRadius: 8,
// //                           offset: const Offset(0, 4),
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(16),
// //                       child: story.imageCover != null && story.imageCover!.isNotEmpty
// //                           ? CustomImage(
// //                         url: story.imageCover!,
// //                         width: 80,
// //                         height: 80,
// //                         boxFit: BoxFit.cover,
// //                       )
// //                           : Container(
// //                         color: Colors.grey[200],
// //                         child: Icon(
// //                           Icons.auto_stories_rounded,
// //                           color: Colors.grey[400],
// //                           size: 32,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 16),
// //
// //                 // Story Info
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       // Title
// //                       Text(
// //                         story.storyTitle ?? 'بدون عنوان',
// //                         style: getBoldStyle(
// //                           color: ColorManager.titleColor,
// //                           fontSize: 18,
// //                         ),
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //
// //                       const SizedBox(height: 8),
// //
// //                       // Problem info
// //                       if (story.problemTitle != null)
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 8,
// //                             vertical: 4,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.orange.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Icon(
// //                                 Icons.psychology_rounded,
// //                                 size: 12,
// //                                 color: Colors.orange[600],
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Flexible(
// //                                 child: Text(
// //                                   story.problemTitle!,
// //                                   style: getBoldStyle(
// //                                     color: Colors.orange[600],
// //                                     fontSize: 10,
// //                                   ),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // Status indicator
// //                 Container(
// //                   width: 8,
// //                   height: 8,
// //                   decoration: BoxDecoration(
// //                     color: Colors.green,
// //                     shape: BoxShape.circle,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildContent() {
// //     return Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Description
// //           Text(
// //             story.storyDescription ?? 'لا يوجد وصف',
// //             style: getRegularStyle(
// //               color: Colors.grey[600],
// //               fontSize: 14,
// //             ),
// //             maxLines: 3,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //
// //           const SizedBox(height: 12),
// //
// //           // Tags row
// //           _buildTagsSection(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTagsSection() {
// //     return Column(
// //       children: [
// //         // First row: Gender and Age
// //         Row(
// //           children: [
// //             _buildTag(
// //               getGenderText(story.gender ?? 'Boy'),
// //               getGenderColor(story.gender ?? 'Boy'),
// //               Icons.person_rounded,
// //             ),
// //             const SizedBox(width: 8),
// //             _buildTag(
// //               '${story.ageGroup ?? 'غير محدد'} سنة',
// //               Colors.green.shade600,
// //               Icons.cake_rounded,
// //             ),
// //             const Spacer(),
// //             Text(
// //               _formatDate(story.createdAt),
// //               style: getRegularStyle(
// //                 color: Colors.grey[500],
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ],
// //         ),
// //
// //         const SizedBox(height: 8),
// //
// //         // Second row: Best friend info
// //         Row(
// //           children: [
// //             Icon(
// //               Icons.favorite_rounded,
// //               size: 14,
// //               color: Colors.red[400],
// //             ),
// //             const SizedBox(width: 6),
// //             Text(
// //               'الصديق المفضل: ',
// //               style: getMediumStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //             _buildTag(
// //               getGenderBestFriendText(story.bestFriendGender ?? "Male"),
// //               getBestFriendColor(story.bestFriendGender ?? "Male"),
// //               Icons.person_outline_rounded,
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildFooter(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.grey[50],
// //         borderRadius: const BorderRadius.only(
// //           bottomLeft: Radius.circular(20),
// //           bottomRight: Radius.circular(20),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           // Quick stats
// //           Expanded(
// //             child: Row(
// //               children: [
// //                 Icon(
// //                   Icons.visibility_rounded,
// //                   size: 16,
// //                   color: Colors.blue[600],
// //                 ),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   'معاينة',
// //                   style: getRegularStyle(
// //                     color: Colors.blue[600],
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Action buttons
// //           Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               _buildActionButton(
// //                 icon: Icons.visibility_rounded,
// //                 color: Colors.blue[600]!,
// //                 onTap: onViewDetails,
// //                 tooltip: 'عرض التفاصيل',
// //               ),
// //               const SizedBox(width: 8),
// //               _buildActionButton(
// //                 icon: Icons.edit_rounded,
// //                 color: Colors.orange[600]!,
// //                 onTap: onEdit,
// //                 tooltip: 'تعديل',
// //               ),
// //               const SizedBox(width: 8),
// //               _buildActionButton(
// //                 icon: Icons.delete_rounded,
// //                 color: Colors.red[600]!,
// //                 onTap: onDelete,
// //                 tooltip: 'حذف',
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTag(String text, Color color, IconData icon) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(
// //           color: color.withOpacity(0.3),
// //           width: 1,
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             icon,
// //             size: 12,
// //             color: color,
// //           ),
// //           const SizedBox(width: 4),
// //           Text(
// //             text,
// //             style: getBoldStyle(
// //               color: color,
// //               fontSize: 10,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildActionButton({
// //     required IconData icon,
// //     required Color color,
// //     required VoidCallback? onTap,
// //     required String tooltip,
// //   }) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(8),
// //           child: Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Icon(
// //               icon,
// //               size: 16,
// //               color: color,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _formatDate(String? dateString) {
// //     if (dateString == null) return '';
// //     try {
// //       final date = DateTime.parse(dateString);
// //       return '${date.day}/${date.month}/${date.year}';
// //     } catch (e) {
// //       return '';
// //     }
// //   }
// // }
// //
// // // Custom painter for background pattern
// // class PatternPainter extends CustomPainter {
// //   final Color color;
// //
// //   PatternPainter({required this.color});
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = color
// //       ..style = PaintingStyle.fill;
// //
// //     const double spacing = 20;
// //     for (double x = 0; x < size.width; x += spacing) {
// //       for (double y = 0; y < size.height; y += spacing) {
// //         canvas.drawCircle(Offset(x, y), 2, paint);
// //       }
// //     }
// //   }
// //
// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // }
// //
// // // Helper functions
// // String getGenderText(String gender) {
// //   switch (gender) {
// //     case 'Boy':
// //       return 'ولد';
// //     case 'Girl':
// //       return 'بنت';
// //     case 'Both':
// //       return 'كلاهما';
// //     default:
// //       return 'غير محدد';
// //   }
// // }
// //
// // String getGenderBestFriendText(String gender) {
// //   switch (gender) {
// //     case 'Male':
// //       return 'ولد';
// //     case 'Female':
// //       return 'بنت';
// //     default:
// //       return 'غير محدد';
// //   }
// // }
// //
// // Color getGenderColor(String gender) {
// //   switch (gender) {
// //     case 'Boy':
// //       return Colors.blue;
// //     case 'Girl':
// //       return Colors.pink;
// //     case 'Both':
// //       return Colors.purple;
// //     default:
// //       return Colors.grey;
// //   }
// // }
// //
// // Color getBestFriendColor(String gender) {
// //   switch (gender) {
// //     case 'Male':
// //       return Colors.blue;
// //     case 'Female':
// //       return Colors.pink;
// //     default:
// //       return Colors.grey;
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:controller_stories/core/resources/color_manager.dart';
// import 'package:controller_stories/core/resources/style_manager.dart';
// import 'package:controller_stories/core/resources/cashed_image.dart';
// import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
//
// class StoryCard extends StatelessWidget {
//   final Stories story;
//   final int index;
//   final VoidCallback? onTap;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onViewDetails;
//
//   const StoryCard({
//     super.key,
//     required this.story,
//     required this.index,
//     this.onTap,
//     this.onEdit,
//     this.onDelete,
//     this.onViewDetails,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool isActive = story.isActive == 1;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: onTap,
//           child: Column(
//             children: [
//               // Header with image and basic info
//               _buildHeader(),
//
//               // Content section
//               _buildContent(),
//
//               // Footer with tags and actions
//               _buildFooter(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             getGenderColor(story.gender ?? 'Boy').withOpacity(0.1),
//             getGenderColor(story.gender ?? 'Boy').withOpacity(0.05),
//           ],
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Background pattern
//           Positioned.fill(
//             child: CustomPaint(
//               painter: PatternPainter(
//                 color: getGenderColor(story.gender ?? 'Boy').withOpacity(0.03),
//               ),
//             ),
//           ),
//
//           // Content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Story Image
//                 Hero(
//                   tag: 'story_image_${story.storyId}',
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: story.imageCover != null && story.imageCover!.isNotEmpty
//                           ? CustomImage(
//                         url: story.imageCover!,
//                         width: 80,
//                         height: 80,
//                         boxFit: BoxFit.cover,
//                       )
//                           : Container(
//                         color: Colors.grey[200],
//                         child: Icon(
//                           Icons.auto_stories_rounded,
//                           color: Colors.grey[400],
//                           size: 32,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Story Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Title
//                       Text(
//                         story.storyTitle ?? 'بدون عنوان',
//                         style: getBoldStyle(
//                           color: ColorManager.titleColor,
//                           fontSize: 18,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       // Problem info
//                       if (story.problemTitle != null)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.psychology_rounded,
//                                 size: 12,
//                                 color: Colors.orange[600],
//                               ),
//                               const SizedBox(width: 4),
//                               Flexible(
//                                 child: Text(
//                                   story.problemTitle!,
//                                   style: getBoldStyle(
//                                     color: Colors.orange[600],
//                                     fontSize: 10,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//                 // Status indicator
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Description
//           Text(
//
//             story.storyDescription ?? 'لا يوجد وصف',
//             style: getRegularStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//
//           const SizedBox(height: 12),
//
//           // Tags row
//           _buildTagsSection(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTagsSection() {
//     return Column(
//       children: [
//         // First row: Gender and Age
//         Row(
//           children: [
//             _buildTag(
//               getGenderText(story.gender ?? 'Boy'),
//               getGenderColor(story.gender ?? 'Boy'),
//               Icons.person_rounded,
//             ),
//             const SizedBox(width: 8),
//             _buildTag(
//               '${story.ageGroup ?? 'غير محدد'} سنة',
//               Colors.green.shade600,
//               Icons.cake_rounded,
//             ),
//             const Spacer(),
//             Text(
//               _formatDate(story.createdAt),
//               style: getRegularStyle(
//                 color: Colors.grey[500],
//                 fontSize: 11,
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 8),
//
//         // Second row: Best friend info
//         Row(
//           children: [
//             Icon(
//               Icons.favorite_rounded,
//               size: 14,
//               color: Colors.red[400],
//             ),
//             const SizedBox(width: 6),
//             Text(
//               'الصديق المفضل: ',
//               style: getMediumStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//             _buildTag(
//               getGenderBestFriendText(story.bestFriendGender ?? "Male"),
//               getBestFriendColor(story.bestFriendGender ?? "Male"),
//               Icons.person_outline_rounded,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFooter(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Quick stats
//           Expanded(
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.visibility_rounded,
//                   size: 16,
//                   color: Colors.blue[600],
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   'معاينة',
//                   style: getRegularStyle(
//                     color: Colors.blue[600],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Action buttons
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildActionButton(
//                 icon: Icons.visibility_rounded,
//                 color: Colors.blue[600]!,
//                 onTap: onViewDetails,
//                 tooltip: 'عرض التفاصيل',
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 icon: Icons.edit_rounded,
//                 color: Colors.orange[600]!,
//                 onTap: onEdit,
//                 tooltip: 'تعديل',
//               ),
//               const SizedBox(width: 8),
//               _buildActionButton(
//                 icon: Icons.delete_rounded,
//                 color: Colors.red[600]!,
//                 onTap: onDelete,
//                 tooltip: 'حذف',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTag(String text, Color color, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 12,
//             color: color,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: getBoldStyle(
//               color: color,
//               fontSize: 10,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback? onTap,
//     required String tooltip,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               size: 16,
//               color: color,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(String? dateString) {
//     if (dateString == null) return '';
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return '';
//     }
//   }
// }
//
// // Custom painter for background pattern
// class PatternPainter extends CustomPainter {
//   final Color color;
//
//   PatternPainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     const double spacing = 20;
//     for (double x = 0; x < size.width; x += spacing) {
//       for (double y = 0; y < size.height; y += spacing) {
//         canvas.drawCircle(Offset(x, y), 2, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// // Helper functions
// String getGenderText(String gender) {
//   switch (gender) {
//     case 'Boy':
//       return 'ولد';
//     case 'Girl':
//       return 'بنت';
//     case 'Both':
//       return 'كلاهما';
//     default:
//       return 'غير محدد';
//   }
// }
//
// String getGenderBestFriendText(String gender) {
//   switch (gender) {
//     case 'Male':
//       return 'ولد';
//     case 'Female':
//       return 'بنت';
//     default:
//       return 'غير محدد';
//   }
// }
//
// Color getGenderColor(String gender) {
//   switch (gender) {
//     case 'Boy':
//       return Colors.blue;
//     case 'Girl':
//       return Colors.pink;
//     case 'Both':
//       return Colors.purple;
//     default:
//       return Colors.grey;
//   }
// }
//
// Color getBestFriendColor(String gender) {
//   switch (gender) {
//     case 'Male':
//       return Colors.blue;
//     case 'Female':
//       return Colors.pink;
//     default:
//       return Colors.grey;
//   }
// }


import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/resources/cashed_image.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';

class StoryCard extends StatelessWidget {
  final Stories story;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewDetails;
  final Function(bool)? onActiveToggle; // New callback for active toggle

  const StoryCard({
    super.key,
    required this.story,
    required this.index,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewDetails,
    this.onActiveToggle, // New parameter
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = story.isActive == 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        // Add border for inactive stories
        border: !isActive ? Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.5,
        ) : null,
      ),
      child: Stack(
        children: [
          // Inactive overlay
          if (!isActive)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Column(
                children: [
                  // Header with image and basic info
                  _buildHeader(),

                  // Content section
                  _buildContent(),

                  // Footer with tags and actions
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    bool isActive = story.isActive == 1;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            getGenderColor(story.gender ?? 'Boy').withOpacity(isActive ? 0.1 : 0.05),
            getGenderColor(story.gender ?? 'Boy').withOpacity(isActive ? 0.05 : 0.02),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: PatternPainter(
                color: getGenderColor(story.gender ?? 'Boy').withOpacity(isActive ? 0.03 : 0.01),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Story Image
                Hero(
                  tag: 'story_image_${story.storyId}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: story.imageCover != null && story.imageCover!.isNotEmpty
                              ? CustomImage(
                            url: story.imageCover!,
                            width: 80,
                            height: 80,
                            boxFit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: Colors.grey[400],
                              size: 32,
                            ),
                          ),
                        ),
                        // Inactive overlay on image
                        if (!isActive)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.visibility_off_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Story Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title with active status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              story.storyTitle ?? 'بدون عنوان',
                              style: getBoldStyle(
                                color: isActive
                                    ? ColorManager.titleColor
                                    : Colors.grey[600]!,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Active status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isActive ? 'نشط' : 'غير نشط',
                              style: getBoldStyle(
                                color: isActive ? Colors.green[600]! : Colors.orange[600]!,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Problem info
                      if (story.problemTitle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(isActive ? 0.1 : 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.psychology_rounded,
                                size: 12,
                                color: Colors.orange[600]?.withOpacity(isActive ? 1.0 : 0.6),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  story.problemTitle!,
                                  style: getBoldStyle(
                                    color: Colors.orange[600]?.withOpacity(isActive ? 1.0 : 0.6),
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Active Switch
                Column(
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isActive,
                        onChanged: onActiveToggle,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                    Text(
                      'نشر',
                      style: getBoldStyle(
                        color: isActive ? Colors.green[600]! : Colors.grey[500]!,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    bool isActive = story.isActive == 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            story.storyDescription ?? 'لا يوجد وصف',
            style: getRegularStyle(
              color: isActive ? Colors.grey[600]! : Colors.grey[400]!,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Tags row
          _buildTagsSection(),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    bool isActive = story.isActive == 1;

    return Column(
      children: [
        // First row: Gender and Age
        Row(
          children: [
            _buildTag(
              getGenderText(story.gender ?? 'Boy'),
              getGenderColor(story.gender ?? 'Boy').withOpacity(isActive ? 1.0 : 0.6),
              Icons.person_rounded,
              isActive,
            ),
            const SizedBox(width: 8),
            _buildTag(
              '${story.ageGroup ?? 'غير محدد'} سنة',
              Colors.green.shade600.withOpacity(isActive ? 1.0 : 0.6),
              Icons.cake_rounded,
              isActive,
            ),
            const Spacer(),
            Text(
              _formatDate(story.createdAt),
              style: getRegularStyle(
                color: Colors.grey[500]?.withOpacity(isActive ? 1.0 : 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Second row: Best friend info
        Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              size: 14,
              color: Colors.red[400]?.withOpacity(isActive ? 1.0 : 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              'الصديق المفضل: ',
              style: getMediumStyle(
                fontSize: 12,
                color: Colors.grey[600]?.withOpacity(isActive ? 1.0 : 0.7),
              ),
            ),
            _buildTag(
              getGenderBestFriendText(story.bestFriendGender ?? "Male"),
              getBestFriendColor(story.bestFriendGender ?? "Male").withOpacity(isActive ? 1.0 : 0.6),
              Icons.person_outline_rounded,
              isActive,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    bool isActive = story.isActive == 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[50] : Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Quick stats
          Expanded(
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  size: 16,
                  color: isActive ? Colors.blue[600] : Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  isActive ? 'نشط' : 'غير نشط',
                  style: getRegularStyle(
                    color: isActive ? Colors.blue[600]! : Colors.grey[500]!,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.visibility_rounded,
                color: Colors.blue[600]!.withOpacity(isActive ? 1.0 : 0.6),
                onTap: onViewDetails,
                tooltip: 'عرض التفاصيل',
                isEnabled: isActive,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.edit_rounded,
                color: Colors.orange[600]!,
                onTap: onEdit,
                tooltip: 'تعديل',
                isEnabled: true,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.delete_rounded,
                color: Colors.red[600]!,
                onTap: onDelete,
                tooltip: 'حذف',
                isEnabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isActive ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(isActive ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: getBoldStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    required String tooltip,
    bool isEnabled = true,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(isEnabled ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color.withOpacity(isEnabled ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 20;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper functions
String getGenderText(String gender) {
  switch (gender) {
    case 'Boy':
      return 'ولد';
    case 'Girl':
      return 'بنت';
    case 'Both':
      return 'كلاهما';
    default:
      return 'غير محدد';
  }
}

String getGenderBestFriendText(String gender) {
  switch (gender) {
    case 'Male':
      return 'ولد';
    case 'Female':
      return 'بنت';
    default:
      return 'غير محدد';
  }
}

Color getGenderColor(String gender) {
  switch (gender) {
    case 'Boy':
      return Colors.blue;
    case 'Girl':
      return Colors.pink;
    case 'Both':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

Color getBestFriendColor(String gender) {
  switch (gender) {
    case 'Male':
      return Colors.blue;
    case 'Female':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}