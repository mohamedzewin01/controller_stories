// lib/features/AudioName/presentation/widgets/add_new_form_widget.dart
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/audio_selection_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/name_input_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/save_button_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/tips_card_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'welcome_card_widget.dart';


class AddNewFormWidget extends StatefulWidget {
  final VoidCallback? onAudioAdded;

  const AddNewFormWidget({
    super.key,
    this.onAudioAdded,
  });

  @override
  State<AddNewFormWidget> createState() => _AddNewFormWidgetState();
}

class _AddNewFormWidgetState extends State<AddNewFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedAudioFile;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Welcome Card
        const WelcomeCardWidget(),
        const SizedBox(height: 24),

        // Name Input
        NameInputWidget(controller: _nameController),
        const SizedBox(height: 24),

        // Audio Selection
        AudioSelectionWidget(
          selectedFile: _selectedAudioFile,
          onFileSelected: (file) {
            setState(() {
              _selectedAudioFile = file;
            });
          },
        ),
        const SizedBox(height: 30),

        // Save Button
        SaveButtonWidget(
          onPressed: _submitForm,
        ),
        const SizedBox(height: 24),

        // Tips Card
        const TipsCardWidget(),
      ],
    );
  }

  void _submitForm() {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى إدخال اسم الطفل');
      return;
    }

    if (_selectedAudioFile == null) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى اختيار ملف صوتي أو تسجيل صوت');
      return;
    }

    // Submit
    try {
      context.read<AudioNameCubit>().addAudioName(
        _nameController.text.trim(),
        _selectedAudioFile!,
      );

      // Reset form
      setState(() {
        _nameController.clear();
        _selectedAudioFile = null;
      });

      // Callback
      if (widget.onAudioAdded != null) {
        widget.onAudioAdded!();
      }
    } catch (e) {
      AudioNavigationUtils.showErrorSnackBar(
          context,
          'خطأ في إضافة الاسم: ${e.toString()}'
      );
    }
  }
}