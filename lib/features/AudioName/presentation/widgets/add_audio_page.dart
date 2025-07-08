import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../core/di/di.dart';
import '../bloc/AudioName_cubit.dart';
import '../widgets/audio_recorder_widget.dart';


class AddAudioPage extends StatefulWidget {
  const AddAudioPage({super.key});

  @override
  State<AddAudioPage> createState() => _AddAudioPageState();
}

class _AddAudioPageState extends State<AddAudioPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedAudioFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _useRecording = false;
  late AudioNameCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt.get<AudioNameCubit>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AudioNameCubit, AudioNameState>(
        listener: (context, state) {
          if (state is AddAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(
              context,
              'تم إضافة الاسم والملف الصوتي بنجاح',
            );
            Navigator.pop(context, true);
          } else if (state is AddAudioNameFailure) {
            AudioNavigationUtils.showErrorSnackBar(
              context,
              'حدث خطأ أثناء إضافة الاسم',
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('إضافة اسم جديد'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // حقل الاسم
                _buildNameField(),
                const SizedBox(height: 20),

                // قسم الملف الصوتي
                _buildAudioSection(),
                const SizedBox(height: 30),

                // زر الحفظ
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
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
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'اسم الطفل',
          hintText: 'أدخل اسم الطفل...',
          prefixIcon: Icon(Icons.person, color: Colors.blue[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildAudioSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'الملف الصوتي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // أزرار الاختيار
          Row(
            children: [
              Expanded(
                child: _buildOptionButton(
                  'اختيار ملف',
                  Icons.file_upload,
                  !_useRecording,
                      () => _pickAudioFile(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOptionButton(
                  'تسجيل',
                  Icons.mic,
                  _useRecording,
                      () => setState(() => _useRecording = true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // عرض المحتوى حسب الاختيار
          if (_useRecording) ...[
            AudioRecorderWidget(
              onAudioRecorded: (file) {
                setState(() {
                  _selectedAudioFile = file;
                });
              },
            ),
          ] else if (_selectedAudioFile != null) ...[
            _buildSelectedFileWidget(),
          ] else ...[
            _buildNoFileWidget(),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, bool isSelected, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[600] : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildSelectedFileWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.audiotrack, color: Colors.green[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تم اختيار الملف',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _selectedAudioFile!.path.split('/').last,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _playPausePreview,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying ? 'إيقاف' : 'استماع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPlaying ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFileWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.audio_file, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'لم يتم اختيار ملف صوتي',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<AudioNameCubit, AudioNameState>(
      builder: (context, state) {
        final isLoading = state is AddAudioNameLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            'حفظ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedAudioFile = File(result.files.single.path!);
        _useRecording = false;
      });
    }
  }

  Future<void> _playPausePreview() async {
    if (_selectedAudioFile == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_selectedAudioFile!.path));
      setState(() => _isPlaying = true);
    }
  }

  void _submitForm() {
    if (_nameController.text.trim().isEmpty) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى إدخال الاسم');
      return;
    }

    if (_selectedAudioFile == null) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى اختيار ملف صوتي');
      return;
    }

    _cubit.addAudioName(_nameController.text.trim(), _selectedAudioFile!);
  }
}


