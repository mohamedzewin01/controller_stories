import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioSelectionWidget extends StatefulWidget {
  final File? selectedFile;
  final Function(File?) onFileSelected;

  const AudioSelectionWidget({
    super.key,
    required this.selectedFile,
    required this.onFileSelected,
  });

  @override
  State<AudioSelectionWidget> createState() => _AudioSelectionWidgetState();
}

class _AudioSelectionWidgetState extends State<AudioSelectionWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _useRecording = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الملف الصوتي',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),

          // Selection Buttons
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  'اختيار ملف',
                  Icons.file_upload,
                  !_useRecording,
                      () {
                    setState(() => _useRecording = false);
                    _pickAudioFile();
                  },
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          // Content based on selection
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _useRecording
                ? _buildRecordingSection()
                : widget.selectedFile != null
                ? _buildSelectedFileSection()
                : _buildNoFileSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(String text, IconData icon, bool isSelected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.indigo[600] : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.grey[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSelected ? 4 : 1,
        ),
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Container(
      key: const ValueKey('recording'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.mic, size: 48, color: Colors.red[600]),
          const SizedBox(height: 16),
          Text(
            'تسجيل الصوت',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط للبدء في التسجيل',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Implement recording functionality
              _showMessage('ميزة التسجيل قيد التطوير');
            },
            icon: const Icon(Icons.fiber_manual_record),
            label: const Text('بدء التسجيل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFileSection() {
    return Container(
      key: const ValueKey('selected'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.audiotrack, color: Colors.green[600], size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تم اختيار الملف الصوتي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.selectedFile!.path.split('/').last,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _playPausePreview,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_isPlaying ? 'إيقاف' : 'استماع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPlaying ? Colors.red[600] : Colors.green[600],
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: _pickAudioFile,
                icon: const Icon(Icons.refresh),
                label: const Text('تغيير الملف'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoFileSection() {
    return Container(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.audio_file, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لم يتم اختيار ملف صوتي',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر ملف من جهازك أو سجل صوتاً جديداً',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        // allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'ogg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        widget.onFileSelected(file);

        setState(() => _useRecording = false);
      }
    } catch (e) {
      _showMessage('خطأ في اختيار الملف: ${e.toString()}');
    }
  }

  Future<void> _playPausePreview() async {
    if (widget.selectedFile == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.play(DeviceFileSource(widget.selectedFile!.path));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      _showMessage('خطأ في تشغيل الملف: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}