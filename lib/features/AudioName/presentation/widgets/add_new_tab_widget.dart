// lib/features/AudioName/presentation/widgets/add_new_tab_widget.dart
import 'package:flutter/material.dart';

import 'add_new_form_widget.dart';

class AddNewTabWidget extends StatelessWidget {
  final VoidCallback? onAudioAdded;

  const AddNewTabWidget({
    super.key,
    this.onAudioAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AddNewFormWidget(
        onAudioAdded: onAudioAdded,
      ),
    );
  }
}