import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../core/di/di.dart';
import '../bloc/AudioName_cubit.dart';
import '../../data/models/response/get_names_audio_dto.dart';


class EditAudioPage extends StatefulWidget {
  final DataAudio audioData;

  const EditAudioPage({super.key, required this.audioData});

  @override
  State<EditAudioPage> createState() => _EditAudioPageState();
}

class _EditAudioPageState extends State<EditAudioPage> {
  late TextEditingController _nameController;
  File? _selectedAudioFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingNew = false;
  bool _isPlayingOriginal = false;
  late AudioNameCubit _cubit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.audioData.name);
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
          if (state is EditAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(
              context,
              'تم تحديث الاسم والملف الصوتي بنجاح',
            );
            Navigator.pop(context, true);
          } else if (state is EditAudioNameFailure) {
            AudioNavigationUtils.showErrorSnackBar(
              context,
              'حدث خطأ أثناء التحديث',
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('تعديل الاسم والملف الصوتي'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                const SizedBox(height: 20),
                _buildOriginalAudioSection(),
                const SizedBox(height: 20),
                _buildNewAudioSection(),
                const SizedBox(height: 30),
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
          prefixIcon: Icon(Icons.person, color: Colors.blue[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildOriginalAudioSection() {
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
          Row(
            children: [
              Icon(Icons.audiotrack, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                'الملف الصوتي الحالي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.audioData.audioFile != null) ...[
            ElevatedButton.icon(
              onPressed: () => _playOriginalAudio(),
              icon: Icon(_isPlayingOriginal ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlayingOriginal ? 'إيقاف' : 'تشغيل الملف الحالي'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isPlayingOriginal ? Colors.red : Colors.blue,
              ),
            ),
          ] else ...[
            const Text(
              'لا يوجد ملف صوتي حالي',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewAudioSection() {
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
          Row(
            children: [
              Icon(Icons.upload_file, color: Colors.green[600]),
              const SizedBox(width: 8),
              const Text(
                'ملف صوتي جديد',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _pickNewAudioFile,
            icon: const Icon(Icons.file_upload),
            label: Text(_selectedAudioFile != null ? 'تم اختيار ملف جديد' : 'اختيار ملف جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedAudioFile != null ? Colors.green : Colors.grey,
            ),
          ),

          if (_selectedAudioFile != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    _selectedAudioFile!.path.split('/').last,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _playNewAudio,
                    icon: Icon(_isPlayingNew ? Icons.pause : Icons.play_arrow),
                    label: Text(_isPlayingNew ? 'إيقاف' : 'تشغيل الملف الجديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPlayingNew ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<AudioNameCubit, AudioNameState>(
      builder: (context, state) {
        final isLoading = state is EditAudioNameLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            'حفظ التغييرات',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Future<void> _pickNewAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedAudioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _playOriginalAudio() async {
    if (widget.audioData.audioFile == null) return;

    if (_isPlayingOriginal) {
      await _audioPlayer.pause();
      setState(() => _isPlayingOriginal = false);
    } else {
      await _audioPlayer.play(UrlSource(widget.audioData.audioFile!));
      setState(() {
        _isPlayingOriginal = true;
        _isPlayingNew = false;
      });
    }
  }

  Future<void> _playNewAudio() async {
    if (_selectedAudioFile == null) return;

    if (_isPlayingNew) {
      await _audioPlayer.pause();
      setState(() => _isPlayingNew = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_selectedAudioFile!.path));
      setState(() {
        _isPlayingNew = true;
        _isPlayingOriginal = false;
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.trim().isEmpty) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى إدخال الاسم');
      return;
    }

    if (_selectedAudioFile == null) {
      AudioNavigationUtils.showErrorSnackBar(context, 'يرجى اختيار ملف صوتي جديد');
      return;
    }

    _cubit.editChildName(
      widget.audioData.nameAudioId!,
      _nameController.text.trim(),
      _selectedAudioFile!,
    );
  }
}