// // lib/features/AudioName/presentation/widgets/add_audio_dialog.dart
// import 'package:controller_stories/features/AudioName/data/models/response/audio_file_empty_dto.dart';
// import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
// import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class AddAudioDialog extends StatefulWidget {
//   final DataFileEmpty item;
//   final AudioNameCubit viewModel;
//
//   const AddAudioDialog({
//     super.key,
//     required this.item,
//     required this.viewModel
//   });
//
//   @override
//   State<AddAudioDialog> createState() => _AddAudioDialogState();
// }
//
// class _AddAudioDialogState extends State<AddAudioDialog> {
//   File? selectedFile;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAudioPlayer();
//   }
//
//   void _setupAudioPlayer() {
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (mounted) {
//         setState(() {
//           _isPlaying = state == PlayerState.playing;
//           if (state == PlayerState.completed) {
//             _isPlaying = false;
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: widget.viewModel,
//       child: BlocListener<AudioNameCubit, AudioNameState>(
//         listener: (context, state) {
//           if (state is EditAudioNameSuccess) {
//             setState(() => _isLoading = false);
//             Navigator.pop(context);
//             _showSuccessMessage('تم إضافة الملف الصوتي بنجاح');
//           } else if (state is EditAudioNameFailure) {
//             setState(() => _isLoading = false);
//             _showError('خطأ في إضافة الملف');
//           } else if (state is EditAudioNameLoading) {
//             setState(() => _isLoading = true);
//           }
//         },
//         child: Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 24),
//                 _buildFileSelection(),
//                 const SizedBox(height: 24),
//                 _buildActionButtons(),
//               ],
//             ),
//           ),
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
//           onPressed: _isLoading ? null : _pickAudioFile,
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
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _isLoading ? null : _playAudio,
//                       icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                       label: Text(_isPlaying ? 'إيقاف' : 'تشغيل'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _isPlaying ? Colors.red : Colors.green,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       onPressed: _isLoading ? null : _removeFile,
//                       icon: const Icon(Icons.delete),
//                       color: Colors.red,
//                       tooltip: 'إزالة الملف',
//                     ),
//                   ],
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
//             onPressed: _isLoading ? null : () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: selectedFile != null && !_isLoading ? _addAudio : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[600],
//               foregroundColor: Colors.white,
//             ),
//             child: _isLoading
//                 ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//                 : const Text('إضافة'),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _pickAudioFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.audio,
//         allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'ogg'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         final file = File(result.files.single.path!);
//
//         // التحقق من وجود الملف
//         if (!await file.exists()) {
//           _showError('الملف غير موجود');
//           return;
//         }
//
//         // التحقق من حجم الملف
//         final fileSize = await file.length();
//         if (fileSize > 10 * 1024 * 1024) { // 10 MB
//           _showError('حجم الملف كبير جداً. الحد الأقصى 10 ميجابايت');
//           return;
//         }
//
//         // التحقق من نوع الملف
//         final extension = file.path.split('.').last.toLowerCase();
//         if (!['mp3', 'wav', 'aac', 'm4a', 'ogg'].contains(extension)) {
//           _showError('نوع الملف غير مدعوم');
//           return;
//         }
//
//         setState(() {
//           selectedFile = file;
//         });
//       }
//     } catch (e) {
//       _showError('خطأ في اختيار الملف');
//     }
//   }
//
//   Future<void> _playAudio() async {
//     if (selectedFile == null) {
//       _showError('لم يتم اختيار ملف');
//       return;
//     }
//
//     if (!await selectedFile!.exists()) {
//       _showError('الملف غير موجود');
//       setState(() => selectedFile = null);
//       return;
//     }
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
//       setState(() => _isPlaying = false);
//     }
//   }
//
//   void _removeFile() {
//     setState(() {
//       selectedFile = null;
//       _isPlaying = false;
//     });
//     _audioPlayer.stop();
//   }
//
//   void _addAudio() {
//     if (selectedFile == null) {
//       _showError('يرجى اختيار ملف صوتي');
//       return;
//     }
//
//     if (!selectedFile!.existsSync()) {
//       _showError('الملف غير موجود');
//       setState(() => selectedFile = null);
//       return;
//     }
//
//     // التحقق من وجود اسم صالح
//     if (widget.item.name == null || widget.item.name!.trim().isEmpty) {
//       _showError('خطأ في بيانات الاسم');
//       return;
//     }
//
//     try {
//       // إيقاف الصوت إذا كان قيد التشغيل
//       if (_isPlaying) {
//         _audioPlayer.stop();
//       }
//
//       context.read<AudioNameCubit>().editChildName(
//         widget.item.nameAudioId!,
//         widget.item.name!,
//         selectedFile!,
//       );
//     } catch (e) {
//       _showError('خطأ في إضافة الملف');
//     }
//   }
//
//   void _showError(String message) {
//     if (mounted) {
//       AudioNavigationUtils.showErrorSnackBar(context, message);
//     }
//   }
//
//   void _showSuccessMessage(String message) {
//     if (mounted) {
//       AudioNavigationUtils.showSuccessSnackBar(context, message);
//     }
//   }
// }