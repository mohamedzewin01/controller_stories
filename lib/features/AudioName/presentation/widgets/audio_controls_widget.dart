// lib/features/AudioName/presentation/widgets/audio_controls_widget.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioControlsWidget extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final AudioPlayer? audioPlayer;

  const AudioControlsWidget({
    super.key,
    required this.duration,
    required this.position,
    this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Progress Bar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.indigo[600],
              inactiveTrackColor: Colors.indigo[200],
              thumbColor: Colors.indigo[600],
              overlayColor: Colors.indigo[600]!.withAlpha(32),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (value) async {
                if (audioPlayer != null) {
                  await audioPlayer!.seek(Duration(seconds: value.toInt()));
                }
              },
            ),
          ),

          // Time Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: TextStyle(fontSize: 12, color: Colors.indigo[600]),
                ),
                Text(
                  _formatDuration(duration),
                  style: TextStyle(fontSize: 12, color: Colors.indigo[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}