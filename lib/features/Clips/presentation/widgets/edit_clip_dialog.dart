import 'dart:io';
import 'package:controller_stories/core/functions/custom_pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/di/di.dart';
import '../../../../core/api/api_constants.dart';
import '../../data/models/response/fetch_clips_dto.dart';
import '../bloc/Clips_cubit.dart';

class EditClipDialog extends StatefulWidget {
  final Clips clip;
  final int storyId;
  final VoidCallback onClipUpdated;

  const EditClipDialog({
    super.key,
    required this.clip,
    required this.storyId,
    required this.onClipUpdated,
  });

  @override
  State<EditClipDialog> createState() => _EditClipDialogState();
}

class _EditClipDialogState extends State<EditClipDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clipTextController;
  late TextEditingController _sortOrderController;

  File? _selectedImage;
  File? _selectedAudio;

  late bool _insertChildName;
  late bool _insertSiblingsName;
  late bool _insertFriendsName;
  late bool _insertBestPlaymate;
  late bool _insertFavoriteImage;

  final ImagePicker _imagePicker = ImagePicker();
  late ClipsCubit _clipsCubit;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clipsCubit = getIt.get<ClipsCubit>();
    _initializeControllers();
  }

  void _initializeControllers() {
    _clipTextController = TextEditingController(text: widget.clip.clipText ?? '');
    _sortOrderController = TextEditingController(
      text: (widget.clip.sortOrder ?? 1).toString(),
    );

    _insertChildName = widget.clip.insertChildName == 'true';
    _insertSiblingsName = widget.clip.insertSiblingsName == 'true';
    _insertFriendsName = widget.clip.insertFriendsName == 'true';
    _insertBestPlaymate = widget.clip.insertBestPlaymate == 'true';
    _insertFavoriteImage = widget.clip.kidsFavoriteImages == 'true';
  }

  @override
  void dispose() {
    _clipTextController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await pickImageDialog(context);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickAudio() async {
    final audio = await pickAudioFile();
    if (audio != null) {
      setState(() => _selectedAudio = audio);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _updateClip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _clipsCubit.editClip(
        clipGroupId: widget.clip.clipGroupId ?? 0,
        clipText: _clipTextController.text.trim(),
        sortOrder: int.tryParse(_sortOrderController.text) ?? 1,
        childName: _insertChildName,
        siblingsName: _insertSiblingsName,
        friendsName: _insertFriendsName,
        bestFriendGender: _insertBestPlaymate,
        imageFavorite: _insertFavoriteImage,
        image: _selectedImage,
        audio: _selectedAudio,
        storyId: widget.storyId,
      );

      widget.onClipUpdated();
    } catch (e) {
      _showErrorSnackBar('خطأ في تحديث المقطع: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClipsCubit, ClipsState>(
      bloc: _clipsCubit,
      listener: (context, state) {
        if (state is ClipsUpdateSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ClipsFailure) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar(state.exception.toString());
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextSection(),
                        const SizedBox(height: 24),
                        _buildSortOrderSection(),
                        const SizedBox(height: 24),
                        _buildMediaSection(),
                        const SizedBox(height: 24),
                        _buildPersonalizationSection(),
                        const SizedBox(height: 32),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'تعديل المقطع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نص المقطع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _clipTextController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'اكتب نص المقطع هنا...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF74B9FF), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),

        ),
      ],
    );
  }

  Widget _buildSortOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ترتيب المقطع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _sortOrderController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'أدخل رقم ترتيب المقطع',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF74B9FF), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: const Icon(Icons.sort, color: Color(0xFF74B9FF)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال رقم الترتيب';
            }
            final intValue = int.tryParse(value);
            if (intValue == null || intValue < 1) {
              return 'يرجى إدخال رقم صحيح أكبر من 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوسائط',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),

        // عرض الصورة الحالية أو المختارة
        _buildCurrentImage(),

        const SizedBox(height: 16),

        // اختيار صورة جديدة
        _buildMediaSelector(
          title: 'تغيير الصورة',
          subtitle: _selectedImage != null
              ? 'تم اختيار صورة جديدة'
              : 'اختر صورة جديدة (اختياري)',
          icon: Icons.image,
          color: const Color(0xFF00B894),
          hasFile: _selectedImage != null,
          onTap: _pickImage,
        ),

        const SizedBox(height: 16),

        // اختيار ملف صوتي جديد
        _buildMediaSelector(
          title: 'تغيير الملف الصوتي',
          subtitle: _selectedAudio != null
              ? 'تم اختيار ملف صوتي جديد'
              : 'اختر ملف صوتي جديد (اختياري)',
          icon: Icons.audiotrack,
          color: const Color(0xFFE17055),
          hasFile: _selectedAudio != null,
          onTap: _pickAudio,
        ),
      ],
    );
  }

  Widget _buildCurrentImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصورة الحالية',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF636E72),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _selectedImage != null
                ? Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            )
                : (widget.clip.imageUrl != null && widget.clip.imageUrl!.isNotEmpty)
                ? CachedNetworkImage(
              imageUrl: "${ApiConstants.urlImage}${widget.clip.imageUrl}",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF74B9FF)),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 48,
                  ),
                ),
              ),
            )
                : Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSelector({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool hasFile,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasFile ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile ? color : Colors.grey[300]!,
            width: hasFile ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasFile ? color : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.check_circle : Icons.add_circle_outline,
              color: hasFile ? color : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خيارات التخصيص',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),

        _buildCheckboxTile(
          title: 'إدراج اسم الطفل',
          value: _insertChildName,
          onChanged: (value) => setState(() => _insertChildName = value ?? false),
          icon: Icons.child_care,
        ),

        _buildCheckboxTile(
          title: 'إدراج أسماء الأشقاء',
          value: _insertSiblingsName,
          onChanged: (value) => setState(() => _insertSiblingsName = value ?? false),
          icon: Icons.family_restroom,
        ),

        _buildCheckboxTile(
          title: 'إدراج أسماء الأصدقاء',
          value: _insertFriendsName,
          onChanged: (value) => setState(() => _insertFriendsName = value ?? false),
          icon: Icons.groups,
        ),

        _buildCheckboxTile(
          title: 'إدراج أفضل صديق',
          value: _insertBestPlaymate,
          onChanged: (value) => setState(() => _insertBestPlaymate = value ?? false),
          icon: Icons.favorite,
        ),
        _buildCheckboxTile(
          title: 'إدراج الصورة المفضلة',
          value: _insertFavoriteImage,
          onChanged: (value) => setState(() => _insertFavoriteImage = value ?? false),
          icon: Icons.image_sharp,
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF74B9FF).withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF74B9FF) : Colors.grey[300]!,
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: value ? const Color(0xFF74B9FF) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value ? const Color(0xFF74B9FF) : Colors.grey[700],
              ),
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF74B9FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _updateClip,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF74B9FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'حفظ التعديلات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}