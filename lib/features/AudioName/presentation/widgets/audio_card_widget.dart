// lib/features/AudioName/presentation/widgets/audio_card_widget.dart
import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/edit_audio_dialog.dart';
import 'package:flutter/material.dart';
import 'audio_controls_widget.dart';
import 'action_buttons_widget.dart';


class AudioCardWidget extends StatelessWidget {
  final DataAudio audio;
  final bool isCurrentPlaying;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final Function(String, String) onPlayPause;

  const AudioCardWidget({
    super.key,
    required this.audio,
    required this.isCurrentPlaying,
    required this.isPlaying,
    required this.duration,
    required this.position,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    final hasAudio = audio.audioFile != null && audio.audioFile!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isCurrentPlaying ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isCurrentPlaying
              ? Border.all(color: Colors.indigo[300]!, width: 2)
              : null,
          gradient: isCurrentPlaying
              ? LinearGradient(
            colors: [Colors.indigo[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeaderRow(context, hasAudio),
              if (isCurrentPlaying && hasAudio) ...[
                const SizedBox(height: 16),
                AudioControlsWidget(
                  duration: duration,
                  position: position,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, bool hasAudio) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        _buildNameAndInfo(hasAudio),
        ActionButtonsWidget(
          audio: audio,
          hasAudio: hasAudio,
          isCurrentPlaying: isCurrentPlaying,
          isPlaying: isPlaying,
          onPlay: hasAudio
              ? () => onPlayPause(audio.audioFile!, audio.nameAudioId.toString())
              : null,
          onEdit: () => _showEditDialog(context),
          onDelete: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'avatar_${audio.nameAudioId}',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isCurrentPlaying
                ? [Colors.indigo[300]!, Colors.indigo[500]!]
                : [Colors.grey[300]!, Colors.grey[400]!],
          ),
        ),
        child: Icon(
          isCurrentPlaying ? Icons.volume_up : Icons.person,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildNameAndInfo(bool hasAudio) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audio.name ?? 'اسم غير محدد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isCurrentPlaying ? Colors.indigo[800] : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                hasAudio ? Icons.audiotrack : Icons.music_off,
                size: 16,
                color: hasAudio ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hasAudio ? 'يحتوي على ملف صوتي' : 'لا يحتوي على ملف صوتي',
                  style: TextStyle(
                    fontSize: 12,
                    color: hasAudio ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            _formatDate(audio.createdAt ?? ''),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditAudioDialog(audio: audio),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAudioDialog(audio: audio),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else {
        return 'منذ قليل';
      }
    } catch (e) {
      return dateStr;
    }
  }
}