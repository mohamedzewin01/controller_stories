// lib/features/AudioName/presentation/utils/audio_navigation.dart

import 'package:flutter/material.dart';


class AudioNavigationUtils {
  // static void navigateToAudioNamesPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const AudioNamesMainPage(),
  //     ),
  //   );
  // }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// lib/features/AudioName/presentation/widgets/audio_player_widget.dart


// lib/features/AudioName/presentation/widgets/loading_widget.dart


// lib/features/AudioName/presentation/widgets/empty_state_widget.dart


// dependencies to add to pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter

  # Existing dependencies...
  bloc: ^8.1.2
  flutter_bloc: ^8.1.3
  injectable: ^2.3.2
  json_annotation: ^4.8.1

  # Audio dependencies
  audioplayers: ^5.2.1

  # File picker
  file_picker: ^6.1.1

  # Permissions
  permission_handler: ^11.0.1

  # Path provider (for file management)
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Existing dev dependencies...
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
*/