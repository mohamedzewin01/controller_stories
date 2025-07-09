// lib/features/AudioName/presentation/widgets/action_buttons_widget.dart
import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
import 'package:flutter/material.dart';


class ActionButtonsWidget extends StatelessWidget {
  final DataAudio audio;
  final bool hasAudio;
  final bool isCurrentPlaying;
  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActionButtonsWidget({
    super.key,
    required this.audio,
    required this.hasAudio,
    required this.isCurrentPlaying,
    required this.isPlaying,
    this.onPlay,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause Button
        if (hasAudio)
          _buildCircularButton(
            icon: isCurrentPlaying && isPlaying ? Icons.pause : Icons.play_arrow,
            color: isCurrentPlaying ? Colors.red : Colors.green,
            onPressed: onPlay,
          ),

        if (hasAudio) const SizedBox(width: 8),

        // Edit Button
        _buildCircularButton(
          icon: Icons.edit,
          color: Colors.orange,
          onPressed: onEdit,
        ),

        const SizedBox(width: 8),

        // Delete Button
        _buildCircularButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}