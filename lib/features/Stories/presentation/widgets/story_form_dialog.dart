// import 'dart:io';
// import 'package:controller_stories/core/functions/custom_pick_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:controller_stories/core/resources/color_manager.dart';
// import 'package:controller_stories/core/resources/style_manager.dart';
// import 'package:controller_stories/core/widgets/custom_text_form.dart';
// import 'package:controller_stories/core/widgets/custom_snack_bar.dart';
// import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
//
// class StoryFormDialog extends StatefulWidget {
//   final Stories? story;
//   final int categoryId;
//   final Function(
//       String title,
//       String description,
//       int problemId,
//
//       String gender,
//       String ageGroup,
//       File imageCover,
//       String? bestFriendGender,
//
//       ) onSave;
//
//   const StoryFormDialog({
//     super.key,
//     this.story,
//     required this.categoryId,
//     required this.onSave,
//   });
//
//   @override
//   State<StoryFormDialog> createState() => _StoryFormDialogState();
// }
//
// class _StoryFormDialogState extends State<StoryFormDialog>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _problemIdController = TextEditingController();
//
//   String _selectedGender = 'Boy';
//   String _bestFriendGender = 'Male';
//   String _selectedAgeGroup = '2-4';
//   File? _selectedImage;
//   bool _isLoading = false;
//   bool _inActive = false;
//
//   final List<String> _genderOptions = ['Boy', 'Girl', 'Both'];
//   final List<String> _bestFriendOptions = ['Male', 'Female'];
//   final List<String> _ageGroupOptions = ['2-4', '5-8', '9-12'];
//
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize controllers with existing data if editing
//     if (widget.story != null) {
//       _titleController.text = widget.story!.storyTitle ?? '';
//       _descriptionController.text = widget.story!.storyDescription ?? '';
//       _problemIdController.text = widget.story!.problemId?.toString() ?? '';
//       _selectedGender = widget.story!.gender ?? 'Boy';
//       _bestFriendGender = widget.story!.bestFriendGender ?? 'Male';
//       _selectedAgeGroup = widget.story!.ageGroup ?? '2-4';
//
//       _inActive = widget.story!.isActive==1 ;
//     }
//
//     // Initialize animations
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.easeOutBack,
//     ));
//
//     // Start animations
//     _slideController.forward();
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _scaleController.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _problemIdController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SlideTransition(
//         position: _slideAnimation,
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.9,
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header
//                   _buildHeader(),
//
//                   const SizedBox(height: 24),
//
//                   // Content
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Image Section
//                           _buildImageSection(),
//
//                           const SizedBox(height: 24),
//
//                           // Form Fields
//                           _buildFormFields(),
//
//                           const SizedBox(height: 24),
//
//                           // Gender Selection
//                           _buildGenderSelection(),
//
//                           const SizedBox(height: 24),
//
//                           // Age Group Selection
//                           _buildAgeGroupSelection(),
//
//                           const SizedBox(height: 24),
//
//                           // Best Friend Selection
//                           _buildBestFriendSelection(),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Action Buttons
//                   _buildActionButtons(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 ColorManager.primaryColor,
//                 ColorManager.primaryColor.withOpacity(0.8),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: ColorManager.primaryColor.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Icon(
//             widget.story == null ? Icons.add_rounded : Icons.edit_rounded,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//
//         const SizedBox(width: 16),
//
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.story == null ? 'إضافة قصة جديدة' : 'تعديل القصة',
//                 style: getBoldStyle(
//                   color: ColorManager.titleColor,
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 widget.story == null
//                     ? 'أنشئ قصة تعليمية جديدة'
//                     : 'عدّل تفاصيل القصة',
//                 style: getRegularStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.close_rounded),
//           style: IconButton.styleFrom(
//             backgroundColor: Colors.grey[100],
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImageSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.image_rounded,
//               color: ColorManager.primaryColor,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               'صورة الغلاف',
//               style: getBoldStyle(
//                 color: ColorManager.titleColor,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 'مطلوب',
//                 style: getBoldStyle(
//                   color: Colors.red,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 12),
//
//         _buildImagePicker(),
//       ],
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _selectedImage != null
//               ? ColorManager.primaryColor.withOpacity(0.3)
//               : Colors.grey[300]!,
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: _selectedImage != null
//           ? Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(14),
//             child: Image.file(
//               _selectedImage!,
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // Remove button
//           Positioned(
//             top: 12,
//             right: 12,
//             child: GestureDetector(
//               onTap: () => setState(() => _selectedImage = null),
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.close_rounded,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//             ),
//           ),
//
//           // Edit button
//           Positioned(
//             top: 12,
//             left: 12,
//             child: GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: ColorManager.primaryColor,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.edit_rounded,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       )
//           : Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: _pickImage,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.add_photo_alternate_rounded,
//                   size: 48,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'اضغط لإضافة صورة الغلاف',
//                   style: getMediumStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'JPG, PNG, أو GIF',
//                   style: getRegularStyle(
//                     color: Colors.grey[500],
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormFields() {
//     return Column(
//       children: [
//         CustomTextFormNew(
//           title: 'عنوان القصة',
//           hintText: 'أدخل عنوان القصة',
//           controller: _titleController,
//           prefixIcon: Icons.title_rounded,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'يرجى إدخال عنوان القصة';
//             }
//             if (value.trim().length < 3) {
//               return 'العنوان يجب أن يكون 3 أحرف على الأقل';
//             }
//             return null;
//           },
//         ),
//
//         CustomTextFormNew(
//           title: 'وصف القصة',
//           hintText: 'أدخل وصفاً تفصيلياً للقصة',
//           controller: _descriptionController,
//           prefixIcon: Icons.description_rounded,
//           maxLines: 4,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'يرجى إدخال وصف القصة';
//             }
//             if (value.trim().length < 10) {
//               return 'الوصف يجب أن يكون 10 أحرف على الأقل';
//             }
//             return null;
//           },
//         ),
//
//         CustomTextFormNew(
//           title: 'رقم المشكلة',
//           hintText: 'أدخل رقم المشكلة المرتبطة',
//           controller: _problemIdController,
//           prefixIcon: Icons.psychology_rounded,
//           textInputType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'يرجى إدخال رقم المشكلة';
//             }
//             if (int.tryParse(value) == null) {
//               return 'يرجى إدخال رقم صحيح';
//             }
//             if (int.parse(value) <= 0) {
//               return 'رقم المشكلة يجب أن يكون أكبر من صفر';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGenderSelection() {
//     return _buildSelectionSection(
//       title: 'الجنس المستهدف',
//       icon: Icons.people_rounded,
//       options: _genderOptions,
//       selectedValue: _selectedGender,
//       onChanged: (value) => setState(() => _selectedGender = value),
//       getDisplayText: getGenderText,
//       getColor: getGenderColor,
//     );
//   }
//
//   Widget _buildAgeGroupSelection() {
//     return _buildSelectionSection(
//       title: 'الفئة العمرية',
//       icon: Icons.cake_rounded,
//       options: _ageGroupOptions,
//       selectedValue: _selectedAgeGroup,
//       onChanged: (value) => setState(() => _selectedAgeGroup = value),
//       getDisplayText: (value) => '$value سنة',
//       getColor: (value) => Colors.green[600]!,
//     );
//   }
//
//   Widget _buildBestFriendSelection() {
//     return _buildSelectionSection(
//       title: 'الصديق المفضل',
//       icon: Icons.favorite_rounded,
//       options: _bestFriendOptions,
//       selectedValue: _bestFriendGender,
//       onChanged: (value) => setState(() => _bestFriendGender = value),
//       getDisplayText: getGenderBestFriendText,
//       getColor: getBestFriendColor,
//     );
//   }
//
//   Widget _buildSelectionSection({
//     required String title,
//     required IconData icon,
//     required List<String> options,
//     required String selectedValue,
//     required Function(String) onChanged,
//     required String Function(String) getDisplayText,
//     required Color Function(String) getColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: ColorManager.primaryColor, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: getBoldStyle(
//                 color: ColorManager.titleColor,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 12),
//
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             final color = getColor(option);
//
//             return GestureDetector(
//               onTap: () => onChanged(option),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected ? color : Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isSelected ? color : Colors.grey[300]!,
//                     width: 2,
//                   ),
//                   boxShadow: isSelected ? [
//                     BoxShadow(
//                       color: color.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ] : null,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       icon,
//                       color: isSelected ? Colors.white : color,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       getDisplayText(option),
//                       style: getBoldStyle(
//                         color: isSelected ? Colors.white : Colors.grey[700],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: _isLoading ? null : () => Navigator.pop(context),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               side: BorderSide(color: Colors.grey[400]!),
//             ),
//             child: Text(
//               'إلغاء',
//               style: getMediumStyle(
//                 color: Colors.grey[600],
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//
//         const SizedBox(width: 16),
//
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _isLoading ? null : _handleSave,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ColorManager.primaryColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               shadowColor: ColorManager.primaryColor.withOpacity(0.3),
//             ),
//             child: _isLoading
//                 ? Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'جاري الحفظ...',
//                   style: getMediumStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             )
//                 : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   widget.story == null ? Icons.add_rounded : Icons.save_rounded,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   widget.story == null ? 'إضافة القصة' : 'حفظ التعديلات',
//                   style: getMediumStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//  Future<void> _pickImage() async {
//    final image = await pickImageDialog(context);
//    if (image != null) {
//      setState(() => _selectedImage = image);
//    }
//   }
//
//
//   void _handleSave() async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedImage == null && widget.story == null) {
//         CustomSnackBar.showErrorSnackBar(
//           context,
//           message: 'يرجى اختيار صورة الغلاف',
//         );
//         return;
//       }
//
//       setState(() => _isLoading = true);
//
//       // Haptic feedback
//       HapticFeedback.mediumImpact();
//
//       try {
//         await widget.onSave(
//           _titleController.text.trim(),
//           _descriptionController.text.trim(),
//           int.parse(_problemIdController.text.trim()),
//           _selectedGender,
//           _selectedAgeGroup,
//           _selectedImage ?? File(''), // For edit mode, API should handle null image
//           _bestFriendGender,
//
//           // isActive
//         );
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }
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

import 'dart:io';
import 'package:controller_stories/core/functions/custom_pick_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/widgets/custom_text_form.dart';
import 'package:controller_stories/core/widgets/custom_snack_bar.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
import 'package:controller_stories/features/Problems/presentation/bloc/Problems_cubit.dart';
import 'package:controller_stories/features/Problems/data/models/response/get_problems_dto.dart';

class StoryFormDialog extends StatefulWidget {
  final Stories? story;
  final int categoryId;
  final Function(
      String title,
      String description,
      int problemId,
      String gender,
      String ageGroup,
      File imageCover,
      String? bestFriendGender,
      ) onSave;

  const StoryFormDialog({
    super.key,
    this.story,
    required this.categoryId,
    required this.onSave,
  });

  @override
  State<StoryFormDialog> createState() => _StoryFormDialogState();
}

class _StoryFormDialogState extends State<StoryFormDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Problem form controllers
  final _problemTitleController = TextEditingController();
  final _problemDescriptionController = TextEditingController();

  String _selectedGender = 'Boy';
  String _bestFriendGender = 'Male';
  String _selectedAgeGroup = '2-4';
  File? _selectedImage;
  bool _isLoading = false;

  // Problem selection variables
  DataProblems? _selectedProblem;
  bool _showNewProblemForm = false;
  bool _isAddingProblem = false;

  final List<String> _genderOptions = ['Boy', 'Girl', 'Both'];
  final List<String> _bestFriendOptions = ['Male', 'Female'];
  final List<String> _ageGroupOptions = ['2-4', '5-8', '9-12'];

  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if editing
    if (widget.story != null) {
      _titleController.text = widget.story!.storyTitle ?? '';
      _descriptionController.text = widget.story!.storyDescription ?? '';
      _selectedGender = widget.story!.gender ?? 'Boy';
      _bestFriendGender = widget.story!.bestFriendGender ?? 'Male';
      _selectedAgeGroup = widget.story!.ageGroup ?? '2-4';
    }

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });

    // Fetch problems when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProblemsCubit>().fetchProblems();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _problemTitleController.dispose();
    _problemDescriptionController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 24),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          _buildImageSection(),

                          const SizedBox(height: 24),

                          // Form Fields
                          _buildFormFields(),

                          const SizedBox(height: 24),

                          // Problem Selection Section
                          _buildProblemSelectionSection(),

                          const SizedBox(height: 24),

                          // Gender Selection
                          _buildGenderSelection(),

                          const SizedBox(height: 24),

                          // Age Group Selection
                          _buildAgeGroupSelection(),

                          const SizedBox(height: 24),

                          // Best Friend Selection
                          _buildBestFriendSelection(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProblemSelectionSection() {
    return BlocConsumer<ProblemsCubit, ProblemsState>(
      listener: (context, state) {
        if (state is AddProblemsSuccess) {
          _showNewProblemForm = false;
          _problemTitleController.clear();
          _problemDescriptionController.clear();
          _isAddingProblem = false;
          context.read<ProblemsCubit>().fetchProblems();
          CustomSnackBar.showSuccessSnackBar(context, message: 'تم إضافة المشكلة بنجاح');
        } else if (state is AddProblemsFailure) {
          _isAddingProblem = false;
          CustomSnackBar.showErrorSnackBar(context, message: 'حدث خطأ في إضافة المشكلة');
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_rounded, color: ColorManager.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'المشكلة',
                  style: getBoldStyle(color: ColorManager.titleColor, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'مطلوب',
                    style: getBoldStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (!_showNewProblemForm) ...[
              // Problem dropdown with add option
              _buildProblemDropdownWithAdd(state),
            ] else ...[
              // New problem form
              _buildNewProblemForm(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildProblemDropdownWithAdd(ProblemsState state) {
    if (state is GetProblemsLoading) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<DropdownMenuItem<String>> items = [];

    if (state is GetProblemsSuccess && state.data?.data != null) {
      final problems = state.data!.data!;

      // Add existing problems
      items.addAll(problems.map((problem) {
        final allValues = items.map((e) => e.value).toList();
        final selectedValue = 'problem_${_selectedProblem?.problemId}';
        print("selectedValue = $selectedValue");
        print("matches = ${allValues.where((e) => e == selectedValue).length}");
        return DropdownMenuItem<String>(


          value: 'problem_${problem.problemId}',
          child: Text(
            problem.problemTitle ?? 'مشكلة بدون عنوان',
            style: getRegularStyle(color: ColorManager.titleColor, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }));
    }

    // Add "Add new problem" option
    items.add(
      DropdownMenuItem<String>(
        value: 'add_new',
        child: Row(
          children: [
            Icon(
              Icons.add_circle_rounded,
              color: ColorManager.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'إضافة مشكلة جديدة',
              style: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );

    String? selectedValue;
    if (_selectedProblem != null) {
      selectedValue = 'problem_${_selectedProblem!.problemId}';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedProblem != null
              ? ColorManager.primaryColor.withOpacity(0.3)
              : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,

        decoration: InputDecoration(
          hintText: 'اختر المشكلة ',
          prefixIcon: Icon(Icons.psychology_rounded, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items,
        onChanged: (String? newValue) {
          if (newValue == 'add_new') {
            setState(() {
              _showNewProblemForm = true;
              _selectedProblem = null;
            });
          } else if (newValue != null && newValue.startsWith('problem_')) {
            final problemId = int.parse(newValue.replaceFirst('problem_', ''));
            if (state is GetProblemsSuccess && state.data?.data != null) {
              final problem = state.data!.data!.firstWhere(
                    (p) => p.problemId == problemId,
              );
              setState(() {
                _selectedProblem = problem;
              });
            }
          }
        },
        validator: (value) {
          if (_selectedProblem == null) {
            return 'يرجى اختيار المشكلة';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNewProblemForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: ColorManager.primaryColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_rounded, color: ColorManager.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'إضافة مشكلة جديدة',
                style: getBoldStyle(color: ColorManager.primaryColor, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showNewProblemForm = false;
                    _problemTitleController.clear();
                    _problemDescriptionController.clear();
                  });
                },
                icon: const Icon(Icons.close_rounded),
                iconSize: 20,
              ),
            ],
          ),

          const SizedBox(height: 16),

          CustomTextFormNew(
            title: 'عنوان المشكلة',
            hintText: 'أدخل عنوان المشكلة',
            controller: _problemTitleController,
            prefixIcon: Icons.title_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال عنوان المشكلة';
              }
              return null;
            },
          ),

          CustomTextFormNew(
            title: 'وصف المشكلة',
            hintText: 'أدخل وصف المشكلة',
            controller: _problemDescriptionController,
            prefixIcon: Icons.description_rounded,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال وصف المشكلة';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showNewProblemForm = false;
                      _problemTitleController.clear();
                      _problemDescriptionController.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: Text(
                    'إلغاء',
                    style: getMediumStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isAddingProblem ? null : _addNewProblem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isAddingProblem
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'جاري الإضافة...',
                        style: getMediumStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'إضافة المشكلة',
                        style: getMediumStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewProblem() async {
    if (_problemTitleController.text.trim().isEmpty ||
        _problemDescriptionController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isAddingProblem = true;
    });

    await context.read<ProblemsCubit>().addProblem(
      problemTitle: _problemTitleController.text.trim(),
      problemDescription: _problemDescriptionController.text.trim(),
    );
  }

  // Rest of the existing methods remain the same...
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ColorManager.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.story == null ? Icons.add_rounded : Icons.edit_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.story == null ? 'إضافة قصة جديدة' : 'تعديل القصة',
                style: getBoldStyle(
                  color: ColorManager.titleColor,
                  fontSize: 20,
                ),
              ),
              Text(
                widget.story == null
                    ? 'أنشئ قصة تعليمية جديدة'
                    : 'عدّل تفاصيل القصة',
                style: getRegularStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.image_rounded,
              color: ColorManager.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'صورة الغلاف',
              style: getBoldStyle(
                color: ColorManager.titleColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'مطلوب',
                style: getBoldStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildImagePicker(),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedImage != null
              ? ColorManager.primaryColor.withOpacity(0.3)
              : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _selectedImage != null
          ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

          // Remove button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => setState(() => _selectedImage = null),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Edit button
          Positioned(
            top: 12,
            left: 12,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      )
          : Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'اضغط لإضافة صورة الغلاف',
                  style: getMediumStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPG, PNG, أو GIF',
                  style: getRegularStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextFormNew(
          title: 'عنوان القصة',
          hintText: 'أدخل عنوان القصة',
          controller: _titleController,
          prefixIcon: Icons.title_rounded,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال عنوان القصة';
            }
            if (value.trim().length < 3) {
              return 'العنوان يجب أن يكون 3 أحرف على الأقل';
            }
            return null;
          },
        ),

        CustomTextFormNew(
          title: 'وصف القصة',
          hintText: 'أدخل وصفاً تفصيلياً للقصة',
          controller: _descriptionController,
          prefixIcon: Icons.description_rounded,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال وصف القصة';
            }
            if (value.trim().length < 10) {
              return 'الوصف يجب أن يكون 10 أحرف على الأقل';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return _buildSelectionSection(
      title: 'الجنس المستهدف',
      icon: Icons.people_rounded,
      options: _genderOptions,
      selectedValue: _selectedGender,
      onChanged: (value) => setState(() => _selectedGender = value),
      getDisplayText: getGenderText,
      getColor: getGenderColor,
    );
  }

  Widget _buildAgeGroupSelection() {
    return _buildSelectionSection(
      title: 'الفئة العمرية',
      icon: Icons.cake_rounded,
      options: _ageGroupOptions,
      selectedValue: _selectedAgeGroup,
      onChanged: (value) => setState(() => _selectedAgeGroup = value),
      getDisplayText: (value) => '$value سنة',
      getColor: (value) => Colors.green[600]!,
    );
  }

  Widget _buildBestFriendSelection() {
    return _buildSelectionSection(
      title: 'الصديق المفضل',
      icon: Icons.favorite_rounded,
      options: _bestFriendOptions,
      selectedValue: _bestFriendGender,
      onChanged: (value) => setState(() => _bestFriendGender = value),
      getDisplayText: getGenderBestFriendText,
      getColor: getBestFriendColor,
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
    required String Function(String) getDisplayText,
    required Color Function(String) getColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorManager.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: getBoldStyle(
                color: ColorManager.titleColor,
                fontSize: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            final color = getColor(option);

            return GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? Colors.white : color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      getDisplayText(option),
                      style: getBoldStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: Text(
              'إلغاء',
              style: getMediumStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: ColorManager.primaryColor.withOpacity(0.3),
            ),
            child: _isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'جاري الحفظ...',
                  style: getMediumStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.story == null ? Icons.add_rounded : Icons.save_rounded,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.story == null ? 'إضافة القصة' : 'حفظ التعديلات',
                  style: getMediumStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final image = await pickImageDialog(context);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && widget.story == null) {
        CustomSnackBar.showErrorSnackBar(
          context,
          message: 'يرجى اختيار صورة الغلاف',
        );
        return;
      }

      if (_selectedProblem == null) {
        CustomSnackBar.showErrorSnackBar(
          context,
          message: 'يرجى اختيار المشكلة',
        );
        return;
      }

      setState(() => _isLoading = true);

      // Haptic feedback
      HapticFeedback.mediumImpact();

      try {
        await widget.onSave(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          _selectedProblem!.problemId!,
          _selectedGender,
          _selectedAgeGroup,
          _selectedImage ?? File(''),
          _bestFriendGender,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
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