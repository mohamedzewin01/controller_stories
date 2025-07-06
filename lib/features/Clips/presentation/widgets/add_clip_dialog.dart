import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/Clips_cubit.dart';

class AddClipDialog extends StatefulWidget {
  final int storyId;
  final VoidCallback onClipAdded;

  const AddClipDialog({
    super.key,
    required this.storyId,
    required this.onClipAdded,
  });

  @override
  State<AddClipDialog> createState() => _AddClipDialogState();
}

class _AddClipDialogState extends State<AddClipDialog> {
  final _formKey = GlobalKey<FormState>();
  final _clipTextController = TextEditingController();
  final _sortOrderController = TextEditingController(text: '1');

  File? _selectedImage;
  File? _selectedAudio;

  bool _insertChildName = false;
  bool _insertSiblingsName = false;
  bool _insertFriendsName = false;
  bool _insertBestPlaymate = false;

  final ImagePicker _imagePicker = ImagePicker();
  late ClipsCubit _clipsCubit;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clipsCubit = getIt.get<ClipsCubit>();
  }

  @override
  void dispose() {
    _clipTextController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedAudio = File(result.files.single.path!);
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الملف الصوتي: $e');
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

  Future<void> _addClip() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      _showErrorSnackBar('يرجى اختيار صورة');
      return;
    }

    if (_selectedAudio == null) {
      _showErrorSnackBar('يرجى اختيار ملف صوتي');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _clipsCubit.addClip(
        storyId: widget.storyId,
        clipText: _clipTextController.text.trim(),
        sortOrder: _sortOrderController.text,
        childName: _insertChildName,
        siblingsName: _insertSiblingsName,
        friendsName: _insertFriendsName,
        bestFriendGender: _insertBestPlaymate,
        image: _selectedImage!,
        audio: _selectedAudio!,
      );

      widget.onClipAdded();
    } catch (e) {
      _showErrorSnackBar('خطأ في إضافة المقطع: $e');
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
        if (state is ClipsAddSuccess) {
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
          colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
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
            Icons.add_circle_outline,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'إضافة مقطع جديد',
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
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
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
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: const Icon(Icons.sort, color: Color(0xFF6C5CE7)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال رقم الترتيب';
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

        // اختيار الصورة
        _buildMediaSelector(
          title: 'اختيار صورة',
          subtitle: _selectedImage != null
              ? 'تم اختيار الصورة'
              : 'لم يتم اختيار صورة',
          icon: Icons.image,
          color: const Color(0xFF00B894),
          hasFile: _selectedImage != null,
          onTap: _pickImage,
        ),

        const SizedBox(height: 16),

        // اختيار الصوت
        _buildMediaSelector(
          title: 'اختيار ملف صوتي',
          subtitle: _selectedAudio != null
              ? 'تم اختيار الملف الصوتي'
              : 'لم يتم اختيار ملف صوتي',
          icon: Icons.audiotrack,
          color: const Color(0xFFE17055),
          hasFile: _selectedAudio != null,
          onTap: _pickAudio,
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
        color: value ? const Color(0xFF6C5CE7).withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF6C5CE7) : Colors.grey[300]!,
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: value ? const Color(0xFF6C5CE7) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value ? const Color(0xFF6C5CE7) : Colors.grey[700],
              ),
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C5CE7),
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
            onPressed: _isLoading ? null : _addClip,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
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
              'إضافة المقطع',
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