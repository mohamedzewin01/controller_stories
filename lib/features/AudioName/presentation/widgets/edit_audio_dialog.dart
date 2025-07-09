// // lib/features/AudioName/presentation/dialogs/edit_audio_dialog.dart
// import 'package:controller_stories/features/AudioName/data/models/response/audio_file_empty_dto.dart';
// import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
// import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:audioplayers/audioplayers.dart';
//
//
//
// class EditAudioDialog extends StatefulWidget {
//   final DataAudio audio;
//
//   const EditAudioDialog({super.key, required this.audio});
//
//   @override
//   State<EditAudioDialog> createState() => _EditAudioDialogState();
// }
//
// class _EditAudioDialogState extends State<EditAudioDialog> {
//   late TextEditingController nameController;
//   File? selectedFile;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlayingNew = false;
//   bool _isPlayingOriginal = false;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.audio.name);
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 500),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 24),
//             _buildNameInput(),
//             const SizedBox(height: 20),
//             if (widget.audio.audioFile != null) ...[
//               _buildCurrentAudioSection(),
//               const SizedBox(height: 16),
//             ],
//             _buildNewAudioSection(),
//             const SizedBox(height: 24),
//             _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Icon(Icons.edit, color: Colors.orange[600]),
//         const SizedBox(width: 8),
//         const Expanded(
//           child: Text(
//             'تعديل الاسم والملف الصوتي',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.close),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNameInput() {
//     return TextField(
//       controller: nameController,
//       decoration: InputDecoration(
//         labelText: 'اسم الطفل',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         prefixIcon: const Icon(Icons.person),
//       ),
//     );
//   }
//
//   Widget _buildCurrentAudioSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue[200]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.audiotrack, color: Colors.blue[600]),
//               const SizedBox(width: 8),
//               const Text(
//                 'الملف الصوتي الحالي',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton.icon(
//             onPressed: _playOriginalAudio,
//             icon: Icon(_isPlayingOriginal ? Icons.pause : Icons.play_arrow),
//             label: Text(_isPlayingOriginal ? 'إيقاف' : 'تشغيل'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _isPlayingOriginal ? Colors.red : Colors.blue,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNewAudioSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ElevatedButton.icon(
//           onPressed: _pickNewAudioFile,
//           icon: const Icon(Icons.file_upload),
//           label: Text(
//             selectedFile != null ? 'تم اختيار ملف جديد' : 'اختيار ملف صوتي جديد',
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: selectedFile != null ? Colors.green : Colors.grey,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 12),
//           ),
//         ),
//         if (selectedFile != null) ...[
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green[200]!),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   selectedFile!.path.split('/').last,
//                   style: const TextStyle(fontSize: 12),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   onPressed: _playNewAudio,
//                   icon: Icon(_isPlayingNew ? Icons.pause : Icons.play_arrow),
//                   label: Text(_isPlayingNew ? 'إيقاف' : 'تشغيل الملف الجديد'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _isPlayingNew ? Colors.red : Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _canSave() ? _saveChanges : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange[600],
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('حفظ'),
//           ),
//         ),
//       ],
//     );
//   }
//
//   bool _canSave() {
//     return nameController.text.trim().isNotEmpty && selectedFile != null;
//   }
//
//   Future<void> _pickNewAudioFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(type: FileType.audio);
//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           selectedFile = File(result.files.single.path!);
//         });
//       }
//     } catch (e) {
//       _showError('خطأ في اختيار الملف');
//     }
//   }
//
//   Future<void> _playOriginalAudio() async {
//     if (widget.audio.audioFile == null) return;
//
//     try {
//       if (_isPlayingOriginal) {
//         await _audioPlayer.pause();
//         setState(() => _isPlayingOriginal = false);
//       } else {
//         await _audioPlayer.play(UrlSource(widget.audio.audioFile!));
//         setState(() {
//           _isPlayingOriginal = true;
//           _isPlayingNew = false;
//         });
//       }
//     } catch (e) {
//       _showError('خطأ في تشغيل الملف');
//     }
//   }
//
//   Future<void> _playNewAudio() async {
//     if (selectedFile == null) return;
//
//     try {
//       if (_isPlayingNew) {
//         await _audioPlayer.pause();
//         setState(() => _isPlayingNew = false);
//       } else {
//         await _audioPlayer.play(DeviceFileSource(selectedFile!.path));
//         setState(() {
//           _isPlayingNew = true;
//           _isPlayingOriginal = false;
//         });
//       }
//     } catch (e) {
//       _showError('خطأ في تشغيل الملف');
//     }
//   }
//
//   void _saveChanges() {
//     try {
//       context.read<AudioNameCubit>().editChildName(
//         widget.audio.nameAudioId!,
//         nameController.text.trim(),
//         selectedFile!,
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       _showError('خطأ في حفظ التغييرات');
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red[600]),
//     );
//   }
// }
//
// // lib/features/AudioName/presentation/dialogs/delete_audio_dialog.dart
//
//
// class DeleteAudioDialog extends StatelessWidget {
//   final DataAudio audio;
//
//   const DeleteAudioDialog({super.key, required this.audio});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Row(
//         children: [
//           Icon(Icons.warning, color: Colors.red[600]),
//           const SizedBox(width: 8),
//           const Text('تأكيد الحذف'),
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('هل أنت متأكد من حذف "${audio.name}"؟'),
//           const SizedBox(height: 8),
//           const Text(
//             'سيتم حذف الاسم والملف الصوتي نهائياً ولا يمكن التراجع عن هذا الإجراء.',
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('إلغاء'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             context.read<AudioNameCubit>().deleteChildName(audio.nameAudioId!);
//             Navigator.pop(context);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//           ),
//           child: const Text('حذف'),
//         ),
//       ],
//     );
//   }
// }
//
// // lib/features/AudioName/presentation/dialogs/add_audio_dialog.dart
//
// class AddAudioDialog extends StatefulWidget {
//   final DataFileEmpty item;
//
//   const AddAudioDialog({super.key, required this.item});
//
//   @override
//   State<AddAudioDialog> createState() => _AddAudioDialogState();
// }
//
// class _AddAudioDialogState extends State<AddAudioDialog> {
//   File? selectedFile;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 400),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 24),
//             _buildFileSelection(),
//             const SizedBox(height: 24),
//             _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Icon(Icons.add_circle, size: 48, color: Colors.blue[600]),
//         const SizedBox(height: 16),
//         Text(
//           'إضافة ملف صوتي لـ "${widget.item.name}"',
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFileSelection() {
//     return Column(
//       children: [
//         ElevatedButton.icon(
//           onPressed: _pickAudioFile,
//           icon: const Icon(Icons.file_upload),
//           label: Text(selectedFile != null ? 'تم اختيار الملف' : 'اختيار ملف صوتي'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: selectedFile != null ? Colors.green : Colors.blue,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//           ),
//         ),
//         if (selectedFile != null) ...[
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green[200]!),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   selectedFile!.path.split('/').last,
//                   style: const TextStyle(fontSize: 12),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   onPressed: _playAudio,
//                   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                   label: Text(_isPlaying ? 'إيقاف' : 'تشغيل'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _isPlaying ? Colors.red : Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: selectedFile != null ? _addAudio : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[600],
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('إضافة'),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _pickAudioFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(type: FileType.audio);
//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           selectedFile = File(result.files.single.path!);
//         });
//       }
//     } catch (e) {
//       _showError('خطأ في اختيار الملف');
//     }
//   }
//
//   Future<void> _playAudio() async {
//     if (selectedFile == null) return;
//
//     try {
//       if (_isPlaying) {
//         await _audioPlayer.pause();
//         setState(() => _isPlaying = false);
//       } else {
//         await _audioPlayer.play(DeviceFileSource(selectedFile!.path));
//         setState(() => _isPlaying = true);
//       }
//     } catch (e) {
//       _showError('خطأ في تشغيل الملف');
//     }
//   }
//
//   void _addAudio() {
//     try {
//       context.read<AudioNameCubit>().editChildName(
//         widget.item.nameAudioId!,
//         widget.item.name!,
//         selectedFile!,
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       _showError('خطأ في إضافة الملف');
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red[600]),
//     );
//   }
// }

// lib/features/AudioName/presentation/widgets/edit_audio_dialog.dart
import 'dart:developer';

import 'package:controller_stories/features/AudioName/data/models/response/audio_file_empty_dto.dart';
import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class EditAudioDialog extends StatefulWidget {
  final DataAudio audio;
  final AudioNameCubit viewModel;
  const EditAudioDialog({super.key, required this.audio, required this.viewModel});

  @override
  State<EditAudioDialog> createState() => _EditAudioDialogState();
}

class _EditAudioDialogState extends State<EditAudioDialog> {
  late TextEditingController nameController;
  File? selectedFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingNew = false;
  bool _isPlayingOriginal = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.audio.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
  value: widget.viewModel,
  child: BlocListener<AudioNameCubit, AudioNameState>(
      listener: (context, state) {
        if (state is EditAudioNameSuccess) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
        } else if (state is EditAudioNameFailure) {
          setState(() => _isLoading = false);
          _showError('خطأ في حفظ التغييرات: ${state.exception.toString()}');
        } else if (state is EditAudioNameLoading) {
          setState(() => _isLoading = true);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildNameInput(),
              const SizedBox(height: 20),
              if (widget.audio.audioFile != null && widget.audio.audioFile!.isNotEmpty) ...[
                _buildCurrentAudioSection(),
                const SizedBox(height: 16),
              ],
              _buildNewAudioSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    ),
);
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.edit, color: Colors.orange[600]),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'تعديل الاسم والملف الصوتي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: nameController,
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: 'اسم الطفل',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.person),
        errorText: nameController.text.trim().isEmpty ? 'يرجى إدخال اسم الطفل' : null,
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildCurrentAudioSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.audiotrack, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                'الملف الصوتي الحالي',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _playOriginalAudio,
            icon: Icon(_isPlayingOriginal ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlayingOriginal ? 'إيقاف' : 'تشغيل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPlayingOriginal ? Colors.red : Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _pickNewAudioFile,
          icon: const Icon(Icons.file_upload),
          label: Text(
            selectedFile != null ? 'تم اختيار ملف جديد' : 'اختيار ملف صوتي جديد',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFile != null ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 12),
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
                  selectedFile!.path.split('/').last,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _playNewAudio,
                  icon: Icon(_isPlayingNew ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlayingNew ? 'إيقاف' : 'تشغيل الملف الجديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlayingNew ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _canSave() && !_isLoading ? _saveChanges : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('حفظ'),
          ),
        ),
      ],
    );
  }

  bool _canSave() {
    return nameController.text.trim().isNotEmpty && selectedFile != null;
  }



  Future<void> _pickNewAudioFile() async {
    try {
      // طلب الإذن أولًا
      if (await Permission.storage.request().isGranted || await Permission.audio.request().isGranted) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
        );

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);

          if (await file.exists()) {
            setState(() {
              selectedFile = file;
            });
          } else {
            _showError('الملف غير موجود');
          }
        }
      } else {
        _showError('يجب السماح للوصول إلى الملفات');
      }
    } catch (e) {
      _showError('خطأ في اختيار الملف: ${e.toString()}');
    }
  }

  // Future<void> _pickNewAudioFile() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.audio,
  //       // allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'ogg'],
  //     );
  //
  //     if (result != null && result.files.single.path != null) {
  //       final file = File(result.files.single.path!);
  //
  //       // التحقق من وجود الملف
  //       if (await file.exists()) {
  //         setState(() {
  //           selectedFile = file;
  //         });
  //       } else {
  //         _showError('الملف غير موجود');
  //       }
  //     }
  //   } catch (e) {
  //     _showError('خطأ في اختيار الملف: ${e.toString()}');
  //   }
  // }

  Future<void> _playOriginalAudio() async {
    if (widget.audio.audioFile == null || widget.audio.audioFile!.isEmpty) {
      _showError('لا يوجد ملف صوتي');
      return;
    }

    try {
      if (_isPlayingOriginal) {
        await _audioPlayer.pause();
        setState(() => _isPlayingOriginal = false);
      } else {
        await _audioPlayer.play(UrlSource(widget.audio.audioFile!));
        setState(() {
          _isPlayingOriginal = true;
          _isPlayingNew = false;
        });
      }
    } catch (e) {
      // _showError('خطأ في تشغيل الملف الأصلي: ${e.toString()}');
    }
  }

  Future<void> _playNewAudio() async {
    if (selectedFile == null) {
      _showError('لم يتم اختيار ملف');
      return;
    }

    if (!await selectedFile!.exists()) {
      _showError('الملف غير موجود');
      setState(() => selectedFile = null);
      return;
    }

    try {
      if (_isPlayingNew) {
        await _audioPlayer.pause();
        setState(() => _isPlayingNew = false);
      } else {
        await _audioPlayer.play(DeviceFileSource(selectedFile!.path));
        setState(() {
          _isPlayingNew = true;
          _isPlayingOriginal = false;
        });
      }
    } catch (e) {
      _showError('خطأ في تشغيل الملف الجديد: ${e.toString()}');
    }
  }

  void _saveChanges() {
    print("dddddddddddddddddddd");
    // التحقق من صحة البيانات
    // if (nameController.text.trim().isEmpty) {
    //   _showError('يرجى إدخال اسم الطفل');
    //   return;
    // }

    if (selectedFile == null) {
      _showError('يرجى اختيار ملف صوتي جديد');
      print('يرجى اختيار ملف صوتي جديد');
      return;
    }

    if (!selectedFile!.existsSync()) {
      _showError('الملف الصوتي غير موجود');
      setState(() => selectedFile = null);
      return;
    }

    try {
      widget.viewModel.editChildName(
        nameAudioId:  widget.audio.nameAudioId!,
        audioFile:selectedFile!,



      );
    } catch (e) {
      log(e.toString());
    }
  }

  void _showError(String message) {
    if (mounted) {
      AudioNavigationUtils.showErrorSnackBar(context, message);
    }
  }
}

// Dialog للحذف
class DeleteAudioDialog extends StatelessWidget {
  final DataAudio audio;
final  AudioNameCubit viewModel;

  const DeleteAudioDialog({super.key, required this.audio, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
  value: viewModel,
  child: BlocListener<AudioNameCubit, AudioNameState>(
      listener: (context, state) {
        if (state is DeleteAudioNameSuccess) {
          Navigator.pop(context);
        } else if (state is DeleteAudioNameFailure) {
          AudioNavigationUtils.showErrorSnackBar(
              context,
              'خطأ في حذف الاسم: ${state.exception.toString()}'
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل أنت متأكد من حذف "${audio.name}"؟'),
            const SizedBox(height: 8),
            const Text(
              'سيتم حذف الاسم والملف الصوتي نهائياً ولا يمكن التراجع عن هذا الإجراء.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          BlocBuilder<AudioNameCubit, AudioNameState>(
            builder: (context, state) {
              final isLoading = state is DeleteAudioNameLoading;

              return ElevatedButton(
                onPressed: isLoading ? null : () {
                  context.read<AudioNameCubit>().deleteChildName(audio.nameAudioId!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('حذف'),
              );
            },
          ),
        ],
      ),
    ),
);
  }
}

// Dialog لإضافة ملف صوتي للأسماء الفارغة
class AddAudioDialog extends StatefulWidget {
  final DataFileEmpty item;
  final AudioNameCubit viewModel;

  const AddAudioDialog({super.key, required this.item, required this.viewModel});

  @override
  State<AddAudioDialog> createState() => _AddAudioDialogState();
}

class _AddAudioDialogState extends State<AddAudioDialog> {
  File? selectedFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => widget.viewModel,
  child: BlocListener<AudioNameCubit, AudioNameState>(
      listener: (context, state) {
        if (state is EditAudioNameSuccess) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
        } else if (state is EditAudioNameFailure) {
          setState(() => _isLoading = false);
          AudioNavigationUtils.showErrorSnackBar(
              context,
              'خطأ في إضافة الملف: ${state.exception.toString()}'
          );
        } else if (state is EditAudioNameLoading) {
          setState(() => _isLoading = true);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFileSelection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    ),
);
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.add_circle, size: 48, color: Colors.blue[600]),
        const SizedBox(height: 16),
        Text(
          'إضافة ملف صوتي لـ "${widget.item.name}"',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFileSelection() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _pickAudioFile,
          icon: const Icon(Icons.file_upload),
          label: Text(
              selectedFile != null ? 'تم اختيار الملف' : 'اختيار ملف صوتي'),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFile != null ? Colors.green : Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        if (selectedFile != null) ...[
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
                  selectedFile!
                      .path
                      .split('/')
                      .last,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _playAudio,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'إيقاف' : 'تشغيل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlaying ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedFile != null && !_isLoading ? _addAudio : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('إضافة'),
          ),
        ),
      ],
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

        if (await file.exists()) {
          setState(() {
            selectedFile = file;
          });
        } else {
          _showError('الملف غير موجود');
        }
      }
    } catch (e) {
      _showError('خطأ في اختيار الملف: ${e.toString()}');
    }
  }

  Future<void> _playAudio() async {
    if (selectedFile == null) return;

    if (!await selectedFile!.exists()) {
      _showError('الملف غير موجود');
      setState(() => selectedFile = null);
      return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.play(DeviceFileSource(selectedFile!.path));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      _showError('خطأ في تشغيل الملف: ${e.toString()}');
    }
  }

  void _addAudio() {
    // if (selectedFile == null) {
    //   _showError('يرجى اختيار ملف صوتي');
    //   print('يرجى اختيار ملف صوتي');
    //   return;
    // }

    // if (!selectedFile!.existsSync()) {
    //   _showError('الملف غير موجود');
    //   setState(() => selectedFile = null);
    //   print('الملف غير موجود');
    //   return;
    // }

    try {
      widget.viewModel.editChildName(
        nameAudioId: widget.item.nameAudioId!,
        audioFile: selectedFile!,
        name: widget.item.name!,



      );
    } catch (e) {
      _showError('خطأ في إضافة الملف: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      AudioNavigationUtils.showErrorSnackBar(context, message);
    }
  }
}
