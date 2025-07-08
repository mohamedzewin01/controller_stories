// // lib/features/AudioName/presentation/pages/audio_names_main_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/AudioName_cubit.dart';
// import '../../domain/entities/audio_name_entities.dart';
// import '../../data/models/response/get_names_audio_dto.dart';
// import '../../data/models/response/audio_file_empty_dto.dart';
// import '../../data/models/response/search_name_audio_dto.dart';
//
// // الصفحة الرئيسية لإدارة الأسماء الصوتية
// class AudioNamesMainPage extends StatefulWidget {
//   const AudioNamesMainPage({super.key});
//
//   @override
//   State<AudioNamesMainPage> createState() => _AudioNamesMainPageState();
// }
//
// class _AudioNamesMainPageState extends State<AudioNamesMainPage>
//     with TickerProviderStateMixin {
//   late AudioNameCubit viewModel;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = getIt.get<AudioNameCubit>();
//     _tabController = TabController(length: 3, vsync: this);
//
//     // جلب البيانات عند بدء التطبيق
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       viewModel.fetchNamesAudio();
//       viewModel.nameAudioEmpty();
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           title: const Text(
//             'إدارة الأسماء الصوتية',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black87,
//           elevation: 0,
//           bottom: TabBar(
//             controller: _tabController,
//             labelColor: Colors.blue[600],
//             unselectedLabelColor: Colors.grey[600],
//             indicatorColor: Colors.blue[600],
//             tabs: const [
//               Tab(icon: Icon(Icons.library_music), text: 'جميع الأسماء'),
//               Tab(icon: Icon(Icons.music_off), text: 'بدون ملفات'),
//               Tab(icon: Icon(Icons.add_circle), text: 'إضافة جديد'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: const [
//             AllNamesAudioTab(),
//             EmptyAudioFilesTab(),
//             AddNewAudioTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // تبويب جميع الأسماء مع الملفات الصوتية
// class AllNamesAudioTab extends StatefulWidget {
//   const AllNamesAudioTab({super.key});
//
//   @override
//   State<AllNamesAudioTab> createState() => _AllNamesAudioTabState();
// }
//
// class _AllNamesAudioTabState extends State<AllNamesAudioTab> {
//   final TextEditingController _searchController = TextEditingController();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String? _currentPlayingId;
//   bool _isPlaying = false;
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _playPauseAudio(String audioUrl, String id) async {
//     if (_currentPlayingId == id && _isPlaying) {
//       await _audioPlayer.pause();
//       setState(() {
//         _isPlaying = false;
//       });
//     } else {
//       await _audioPlayer.play(UrlSource(audioUrl));
//       setState(() {
//         _currentPlayingId = id;
//         _isPlaying = true;
//       });
//     }
//   }
//
//   void _searchNames(String query) {
//     if (query.isNotEmpty) {
//       context.read<AudioNameCubit>().searchAudioName(query);
//     } else {
//       context.read<AudioNameCubit>().fetchNamesAudio();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // شريط البحث
//         Container(
//           margin: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: _searchController,
//             onChanged: _searchNames,
//             decoration: InputDecoration(
//               hintText: 'البحث عن اسم...',
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               suffixIcon: _searchController.text.isNotEmpty
//                   ? IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () {
//                   _searchController.clear();
//                   _searchNames('');
//                 },
//               )
//                   : null,
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.all(16),
//             ),
//           ),
//         ),
//
//         // قائمة الأسماء
//         Expanded(
//           child: BlocBuilder<AudioNameCubit, AudioNameState>(
//             builder: (context, state) {
//               if (state is GetAudioNameLoading || state is SearchNameLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               if (state is GetAudioNameSuccess) {
//                 return _buildAudioList(state.getNamesAudioEntity.data ?? []);
//               }
//
//               if (state is SearchNameSuccess) {
//                 return _buildSearchResults(state.searchNameAudioEntity.data ?? []);
//               }
//
//               if (state is GetAudioNameFailure || state is SearchNameFailure) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error, size: 64, color: Colors.red[300]),
//                       const SizedBox(height: 16),
//                       const Text('حدث خطأ في تحميل البيانات'),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           context.read<AudioNameCubit>().fetchNamesAudio();
//                         },
//                         child: const Text('إعادة المحاولة'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               return const Center(child: Text('لا توجد بيانات'));
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAudioList(List<DataAudio> audioList) {
//     if (audioList.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.music_note, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(
//               'لا توجد ملفات صوتية',
//               style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: audioList.length,
//       itemBuilder: (context, index) {
//         final audio = audioList[index];
//         return _buildAudioCard(audio);
//       },
//     );
//   }
//
//   Widget _buildSearchResults(List<DataSearch> searchResults) {
//     if (searchResults.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(
//               'لم يتم العثور على نتائج',
//               style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: searchResults.length,
//       itemBuilder: (context, index) {
//         final search = searchResults[index];
//         // تحويل DataSearch إلى DataAudio للاستخدام مع _buildAudioCard
//         final audio = DataAudio(
//           nameAudioId: search.nameAudioId,
//           name: search.name,
//           audioFile: search.audioFile,
//           createdAt: search.createdAt,
//         );
//         return _buildAudioCard(audio);
//       },
//     );
//   }
//
//   Widget _buildAudioCard(DataAudio audio) {
//     final isCurrentPlaying = _currentPlayingId == audio.nameAudioId.toString();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.blue[100],
//           child: Icon(
//             Icons.person,
//             color: Colors.blue[600],
//             size: 28,
//           ),
//         ),
//         title: Text(
//           audio.name ?? 'اسم غير محدد',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   audio.createdAt ?? '',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // زر التشغيل/الإيقاف
//             Container(
//               decoration: BoxDecoration(
//                 color: isCurrentPlaying ? Colors.red[100] : Colors.green[100],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   isCurrentPlaying && _isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: isCurrentPlaying ? Colors.red[600] : Colors.green[600],
//                 ),
//                 onPressed: () {
//                   if (audio.audioFile != null) {
//                     _playPauseAudio(
//                       audio.audioFile!,
//                       audio.nameAudioId.toString(),
//                     );
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(width: 8),
//             // زر التعديل
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.orange[100],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: IconButton(
//                 icon: Icon(Icons.edit, color: Colors.orange[600]),
//                 onPressed: () {
//                   _showEditDialog(audio);
//                 },
//               ),
//             ),
//             const SizedBox(width: 8),
//             // زر الحذف
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red[100],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red[600]),
//                 onPressed: () {
//                   _showDeleteDialog(audio);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showEditDialog(DataAudio audio) {
//     final nameController = TextEditingController(text: audio.name);
//     File? selectedFile;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تعديل الاسم والملف الصوتي'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'الاسم',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await FilePicker.platform.pickFiles(
//                   type: FileType.audio,
//                 );
//                 if (result != null) {
//                   selectedFile = File(result.files.single.path!);
//                 }
//               },
//               child: const Text('اختيار ملف صوتي جديد'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty && selectedFile != null) {
//                 context.read<AudioNameCubit>().editChildName(
//                   audio.nameAudioId!,
//                   nameController.text,
//                   selectedFile!,
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('حفظ'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteDialog(DataAudio audio) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: Text('هل أنت متأكد من حذف "${audio.name}"؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               context.read<AudioNameCubit>().deleteChildName(audio.nameAudioId!);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('حذف'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // تبويب الأسماء بدون ملفات صوتية
// class EmptyAudioFilesTab extends StatefulWidget {
//   const EmptyAudioFilesTab({super.key});
//
//   @override
//   State<EmptyAudioFilesTab> createState() => _EmptyAudioFilesTabState();
// }
//
// class _EmptyAudioFilesTabState extends State<EmptyAudioFilesTab> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AudioNameCubit, AudioNameState>(
//       builder: (context, state) {
//         if (state is EmptyAudioNameLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is EmptyAudioNameSuccess) {
//           final emptyList = state.audioFileEmptyEntity.data ?? [];
//
//           if (emptyList.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle, size: 64, color: Colors.green[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'جميع الأسماء لديها ملفات صوتية!',
//                     style: TextStyle(fontSize: 18, color: Colors.green[600]),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: emptyList.length,
//             itemBuilder: (context, index) {
//               final item = emptyList[index];
//               return _buildEmptyAudioCard(item);
//             },
//           );
//         }
//
//         if (state is EmptyAudioNameFailure) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error, size: 64, color: Colors.red[300]),
//                 const SizedBox(height: 16),
//                 const Text('حدث خطأ في تحميل البيانات'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<AudioNameCubit>().nameAudioEmpty();
//                   },
//                   child: const Text('إعادة المحاولة'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return const Center(child: Text('لا توجد بيانات'));
//       },
//     );
//   }
//
//   Widget _buildEmptyAudioCard(DataFileEmpty item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.orange[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.orange[100],
//           child: Icon(
//             Icons.person_outline,
//             color: Colors.orange[600],
//             size: 28,
//           ),
//         ),
//         title: Text(
//           item.name ?? 'اسم غير محدد',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.warning, size: 14, color: Colors.orange[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   'لا يوجد ملف صوتي',
//                   style: TextStyle(color: Colors.orange[600], fontSize: 12),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 2),
//             Row(
//               children: [
//                 Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Text(
//                   item.createdAt ?? '',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Container(
//           decoration: BoxDecoration(
//             color: Colors.blue[100],
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.add, color: Colors.blue[600]),
//             onPressed: () {
//               _showAddAudioDialog(item);
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showAddAudioDialog(DataFileEmpty item) {
//     File? selectedFile;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('إضافة ملف صوتي لـ "${item.name}"'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('اختر ملف صوتي لإضافته'),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final result = await FilePicker.platform.pickFiles(
//                   type: FileType.audio,
//                 );
//                 if (result != null) {
//                   selectedFile = File(result.files.single.path!);
//                 }
//               },
//               icon: const Icon(Icons.file_upload),
//               label: const Text('اختيار ملف'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (selectedFile != null) {
//                 context.read<AudioNameCubit>().editChildName(
//                   item.nameAudioId!,
//                   item.name!,
//                   selectedFile!,
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('إضافة'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // تبويب إضافة اسم وملف صوتي جديد
// class AddNewAudioTab extends StatefulWidget {
//   const AddNewAudioTab({super.key});
//
//   @override
//   State<AddNewAudioTab> createState() => _AddNewAudioTabState();
// }
//
// class _AddNewAudioTabState extends State<AddNewAudioTab> {
//   final TextEditingController _nameController = TextEditingController();
//   File? _selectedAudioFile;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickAudioFile() async {
//     // طلب الإذن
//     final permission = await Permission.storage.request();
//     if (!permission.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يجب منح إذن الوصول للملفات')),
//       );
//       return;
//     }
//
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.audio,
//       allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
//     );
//
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _selectedAudioFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> _playPausePreview() async {
//     if (_selectedAudioFile == null) return;
//
//     if (_isPlaying) {
//       await _audioPlayer.pause();
//       setState(() {
//         _isPlaying = false;
//       });
//     } else {
//       await _audioPlayer.play(DeviceFileSource(_selectedAudioFile!.path));
//       setState(() {
//         _isPlaying = true;
//       });
//     }
//   }
//
//   void _submitForm() {
//     if (_nameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى إدخال الاسم')),
//       );
//       return;
//     }
//
//     if (_selectedAudioFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى اختيار ملف صوتي')),
//       );
//       return;
//     }
//
//     // إضافة الملف الصوتي
//     context.read<AudioNameCubit>().addAudioName(_nameController.text, _selectedAudioFile!);
//
//     // إعادة تعيين النموذج
//     setState(() {
//       _nameController.clear();
//       _selectedAudioFile = null;
//       _isPlaying = false;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('تم إضافة الاسم والملف الصوتي بنجاح')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // حقل إدخال الاسم
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'اسم الطفل',
//                 hintText: 'أدخل اسم الطفل هنا...',
//                 prefixIcon: Icon(Icons.person),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.all(16),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // قسم اختيار الملف الصوتي
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   _selectedAudioFile != null ? Icons.audiotrack : Icons.audio_file,
//                   size: 48,
//                   color: _selectedAudioFile != null ? Colors.green[600] : Colors.grey[400],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   _selectedAudioFile != null
//                       ? 'تم اختيار الملف الصوتي'
//                       : 'لم يتم اختيار ملف صوتي',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: _selectedAudioFile != null ? Colors.green[600] : Colors.grey[600],
//                   ),
//                 ),
//                 if (_selectedAudioFile != null) ...[
//                   const SizedBox(height: 8),
//                   Text(
//                     _selectedAudioFile!.path.split('/').last,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _pickAudioFile,
//                       icon: const Icon(Icons.file_upload),
//                       label: const Text('اختيار ملف'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[600],
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       ),
//                     ),
//                     if (_selectedAudioFile != null)
//                       ElevatedButton.icon(
//                         onPressed: _playPausePreview,
//                         icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                         label: Text(_isPlaying ? 'إيقاف' : 'استماع'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _isPlaying ? Colors.red[600] : Colors.green[600],
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // زر الحفظ
//           ElevatedButton(
//             onPressed: _submitForm,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green[600],
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'حفظ الاسم والملف الصوتي',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//
//           const Spacer(),
//
//           // رسالة تعليمية
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.blue[200]!),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info, color: Colors.blue[600]),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'تأكد من وضوح نطق الاسم في الملف الصوتي لضمان تسجيل دقيق',
//                     style: TextStyle(
//                       color: Colors.blue[800],
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/features/AudioName/presentation/pages/audio_names_main_page_enhanced.dart
import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../../../../core/di/di.dart';
import '../bloc/AudioName_cubit.dart';
import '../../domain/entities/audio_name_entities.dart';
import '../../data/models/response/get_names_audio_dto.dart';
import '../../data/models/response/audio_file_empty_dto.dart';
import '../../data/models/response/search_name_audio_dto.dart';
import '../widgets/animated_audio_card.dart';
import '../widgets/statistics_widget.dart';
import '../widgets/custom_fab.dart';
import '../widgets/audio_recorder_widget.dart';


class AudioNamesMainPageEnhanced extends StatefulWidget {
  const AudioNamesMainPageEnhanced({super.key});

  @override
  State<AudioNamesMainPageEnhanced> createState() => _AudioNamesMainPageEnhancedState();
}

class _AudioNamesMainPageEnhancedState extends State<AudioNamesMainPageEnhanced>
    with TickerProviderStateMixin {
  late AudioNameCubit viewModel;
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingId;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<AudioNameCubit>();
    _tabController = TabController(length: 3, vsync: this);
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // جلب البيانات عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchNamesAudio();
      viewModel.nameAudioEmpty();
    });

    // إعداد مستمع التشغيل الصوتي
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // إعداد مستمع انتهاء التشغيل
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _currentPlayingId = null;
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseAudio(String audioUrl, String id) async {
    if (_currentPlayingId == id && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
      setState(() {
        _currentPlayingId = id;
        _isPlaying = true;
      });
    }
  }

  void _showQuickAddDialog() {
    showDialog(
      context: context,
      builder: (context) => const QuickAddDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocListener<AudioNameCubit, AudioNameState>(
        listener: (context, state) {
          if (state is AddAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(
              context,
              'تم إضافة الاسم والملف الصوتي بنجاح',
            );
          } else if (state is EditAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(
              context,
              'تم تحديث الاسم والملف الصوتي بنجاح',
            );
          } else if (state is DeleteAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(
              context,
              'تم حذف الاسم بنجاح',
            );
          } else if (state is AddAudioNameFailure ||
              state is EditAudioNameFailure ||
              state is DeleteAudioNameFailure) {
            AudioNavigationUtils.showErrorSnackBar(
              context,
              'حدث خطأ أثناء العملية',
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    // title: const Text(
                    //   'إدارة الأسماء الصوتية',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: BlocBuilder<AudioNameCubit, AudioNameState>(
                        builder: (context, state) {
                          int totalNames = 0;
                          int namesWithAudio = 0;
                          int namesWithoutAudio = 0;

                          if (state is GetAudioNameSuccess) {
                            namesWithAudio = state.getNamesAudioEntity.data?.length ?? 0;
                          }
                          if (state is EmptyAudioNameSuccess) {
                            namesWithoutAudio = state.audioFileEmptyEntity.data?.length ?? 0;
                          }

                          totalNames = namesWithAudio + namesWithoutAudio;

                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: AudioNameStatisticsWidget(
                              totalNames: totalNames,
                              namesWithAudio: namesWithAudio,
                              namesWithoutAudio: namesWithoutAudio,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:  Colors.white

                      ),

                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.blue[600],
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Colors.blue[600],
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(icon: Icon(Icons.library_music), text: 'جميع الأسماء'),
                          Tab(icon: Icon(Icons.music_off), text: 'بدون ملفات'),
                          Tab(icon: Icon(Icons.add_circle), text: 'إضافة جديد'),
                        ],
                      ),
                    ),
                  ),

                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,

              children: [
                EnhancedAllNamesAudioTab(
                  audioPlayer: _audioPlayer,
                  currentPlayingId: _currentPlayingId,
                  isPlaying: _isPlaying,
                  onPlayPause: _playPauseAudio,
                ),
                const EnhancedEmptyAudioFilesTab(),
                const EnhancedAddNewAudioTab(),
              ],
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(
            onPressed: _showQuickAddDialog,
            tooltip: 'إضافة سريعة',
          ),
        ),
      ),
    );
  }
}

// تبويب محسن لجميع الأسماء
class EnhancedAllNamesAudioTab extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String? currentPlayingId;
  final bool isPlaying;
  final Function(String, String) onPlayPause;

  const EnhancedAllNamesAudioTab({
    super.key,
    required this.audioPlayer,
    required this.currentPlayingId,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  State<EnhancedAllNamesAudioTab> createState() => _EnhancedAllNamesAudioTabState();
}

class _EnhancedAllNamesAudioTabState extends State<EnhancedAllNamesAudioTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchNames(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      context.read<AudioNameCubit>().searchAudioName(query);
    } else {
      context.read<AudioNameCubit>().fetchNamesAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AudioNameCubit>().fetchNamesAudio();
      },
      child: Column(
        children: [
          // شريط البحث المحسن
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _searchNames,
              decoration: InputDecoration(
                hintText: 'البحث عن اسم...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchNames('');
                  },
                )
                    : IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // إضافة البحث الصوتي هنا
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // قائمة الأسماء
          Expanded(
            child: BlocBuilder<AudioNameCubit, AudioNameState>(
              builder: (context, state) {
                if (state is GetAudioNameLoading || state is SearchNameLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GetAudioNameSuccess) {
                  return _buildAudioList(state.getNamesAudioEntity.data ?? []);
                }

                if (state is SearchNameSuccess) {
                  return _buildSearchResults(state.searchNameAudioEntity.data ?? []);
                }

                if (state is GetAudioNameFailure || state is SearchNameFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        const Text('حدث خطأ في تحميل البيانات'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<AudioNameCubit>().fetchNamesAudio();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: Text('لا توجد بيانات'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioList(List<DataAudio> audioList) {
    if (audioList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد ملفات صوتية',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة أسماء وملفات صوتية',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // التبديل إلى تبويب الإضافة
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة اسم جديد'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: audioList.length,
      itemBuilder: (context, index) {
        final audio = audioList[index];
        final isCurrentPlaying = widget.currentPlayingId == audio.nameAudioId.toString();

        return AnimatedAudioCard(
          audio: audio,
          isPlaying: isCurrentPlaying && widget.isPlaying,
          onPlay: () {
            if (audio.audioFile != null) {
              widget.onPlayPause(
                audio.audioFile!,
                audio.nameAudioId.toString(),
              );
            }
          },
          onEdit: () => _showEditDialog(audio),
          onDelete: () => _showDeleteDialog(audio),
        );
      },
    );
  }

  Widget _buildSearchResults(List<DataSearch> searchResults) {
    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'لم يتم العثور على نتائج',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب البحث بكلمات مختلفة',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final search = searchResults[index];
        final audio = DataAudio(
          nameAudioId: search.nameAudioId,
          name: search.name,
          audioFile: search.audioFile,
          createdAt: search.createdAt,
        );
        final isCurrentPlaying = widget.currentPlayingId == audio.nameAudioId.toString();

        return AnimatedAudioCard(
          audio: audio,
          isPlaying: isCurrentPlaying && widget.isPlaying,
          onPlay: () {
            if (audio.audioFile != null) {
              widget.onPlayPause(
                audio.audioFile!,
                audio.nameAudioId.toString(),
              );
            }
          },
          onEdit: () => _showEditDialog(audio),
          onDelete: () => _showDeleteDialog(audio),
        );
      },
    );
  }

  void _showEditDialog(DataAudio audio) {
    showDialog(
      context: context,
      builder: (context) => EditAudioDialog(audio: audio),
    );
  }

  void _showDeleteDialog(DataAudio audio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف "${audio.name}"؟\nسيتم حذف الاسم والملف الصوتي نهائياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AudioNameCubit>().deleteChildName(audio.nameAudioId!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// باقي الصفحات والمكونات...
class EnhancedEmptyAudioFilesTab extends StatelessWidget {
  const EnhancedEmptyAudioFilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioNameCubit, AudioNameState>(
      builder: (context, state) {
        if (state is EmptyAudioNameLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmptyAudioNameSuccess) {
          final emptyList = state.audioFileEmptyEntity.data ?? [];

          if (emptyList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: Colors.green[400]),
                  const SizedBox(height: 16),
                  Text(
                    'ممتاز! 🎉',
                    style: TextStyle(fontSize: 24, color: Colors.green[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جميع الأسماء لديها ملفات صوتية',
                    style: TextStyle(fontSize: 18, color: Colors.green[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: emptyList.length,
            itemBuilder: (context, index) {
              final item = emptyList[index];
              return _buildEmptyAudioCard(item, context);
            },
          );
        }

        if (state is EmptyAudioNameFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text('حدث خطأ في تحميل البيانات'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AudioNameCubit>().nameAudioEmpty();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }

  Widget _buildEmptyAudioCard(DataFileEmpty item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.orange[100],
          child: Icon(
            Icons.person_outline,
            color: Colors.orange[600],
            size: 28,
          ),
        ),
        title: Text(
          item.name ?? 'اسم غير محدد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.warning, size: 14, color: Colors.orange[600]),
                const SizedBox(width: 4),
                Text(
                  'لا يوجد ملف صوتي',
                  style: TextStyle(color: Colors.orange[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  item.createdAt ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.blue[600]),
            onPressed: () {
              _showAddAudioDialog(item, context);
            },
          ),
        ),
      ),
    );
  }

  void _showAddAudioDialog(DataFileEmpty item, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddAudioDialog(item: item),
    );
  }
}

class EnhancedAddNewAudioTab extends StatefulWidget {
  const EnhancedAddNewAudioTab({super.key});

  @override
  State<EnhancedAddNewAudioTab> createState() => _EnhancedAddNewAudioTabState();
}

class _EnhancedAddNewAudioTabState extends State<EnhancedAddNewAudioTab> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedAudioFile;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _useRecording = false;

  @override
  void dispose() {
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
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
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(DeviceFileSource(_selectedAudioFile!.path));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.trim().isEmpty) {
      AudioNavigationUtils.showErrorSnackBar(
        context,
        'يرجى إدخال الاسم',
      );
      return;
    }

    if (_selectedAudioFile == null) {
      AudioNavigationUtils.showErrorSnackBar(
        context,
        'يرجى اختيار ملف صوتي أو تسجيل صوت',
      );
      return;
    }

    context.read<AudioNameCubit>().addAudioName(
      _nameController.text.trim(),
      _selectedAudioFile!,
    );

    // إعادة تعيين النموذج
    setState(() {
      _nameController.clear();
      _selectedAudioFile = null;
      _isPlaying = false;
      _useRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // رسالة ترحيبية
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.add_circle, size: 48, color: Colors.blue[600]),
                const SizedBox(height: 12),
                Text(
                  'إضافة اسم جديد',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أضف اسم الطفل مع تسجيل صوتي واضح للنطق الصحيح',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // حقل إدخال الاسم
          Container(
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
                hintText: 'أدخل اسم الطفل هنا...',
                prefixIcon: Icon(Icons.person, color: Colors.blue[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
                labelStyle: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // خيارات الصوت
          Container(
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
                Text(
                  'إضافة الملف الصوتي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),

                // أزرار اختيار نوع الإدخال
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _useRecording = false;
                          });
                          _pickAudioFile();
                        },
                        icon: const Icon(Icons.file_upload),
                        label: const Text('اختيار ملف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_useRecording ? Colors.blue[600] : Colors.grey[300],
                          foregroundColor: !_useRecording ? Colors.white : Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _useRecording = true;
                            _selectedAudioFile = null;
                          });
                        },
                        icon: const Icon(Icons.mic),
                        label: const Text('تسجيل صوت'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _useRecording ? Colors.red[600] : Colors.grey[300],
                          foregroundColor: _useRecording ? Colors.white : Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // عرض حالة الملف أو التسجيل
                if (_useRecording) ...[
                  AudioRecorderWidget(
                    onAudioRecorded: (file) {
                      setState(() {
                        _selectedAudioFile = file;
                      });
                    },
                  ),
                ] else if (_selectedAudioFile != null) ...[
                  Container(
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
                                    'تم اختيار الملف الصوتي',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _selectedAudioFile!.path.split('/').last,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
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
                            backgroundColor: _isPlaying ? Colors.red[600] : Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
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
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),

          // زر الحفظ
          BlocBuilder<AudioNameCubit, AudioNameState>(
            builder: (context, state) {
              final isLoading = state is AddAudioNameLoading;

              return ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isLoading ? 0 : 2,
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'حفظ الاسم والملف الصوتي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // نصائح مفيدة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Text(
                      'نصائح للحصول على أفضل النتائج:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTip('اجعل النطق واضحاً ومفهوماً'),
                _buildTip('سجل في مكان هادئ بدون ضوضاء'),
                _buildTip('كرر الاسم 2-3 مرات في التسجيل'),
                _buildTip('استخدم نبرة طبيعية ومريحة'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.amber[700],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.amber[800],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// مربعات حوار مساعدة
class QuickAddDialog extends StatelessWidget {
  const QuickAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('إضافة سريعة'),
      content: const Text('انتقل إلى تبويب "إضافة جديد" لإضافة اسم وملف صوتي'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // التبديل إلى تبويب الإضافة
          },
          child: const Text('انتقال'),
        ),
      ],
    );
  }
}

class EditAudioDialog extends StatefulWidget {
  final DataAudio audio;

  const EditAudioDialog({super.key, required this.audio});

  @override
  State<EditAudioDialog> createState() => _EditAudioDialogState();
}

class _EditAudioDialogState extends State<EditAudioDialog> {
  late TextEditingController nameController;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.audio.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('تعديل الاسم والملف الصوتي'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'الاسم',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
              );
              if (result != null) {
                setState(() {
                  selectedFile = File(result.files.single.path!);
                });
              }
            },
            icon: const Icon(Icons.file_upload),
            label: Text(selectedFile != null ? 'تم اختيار ملف جديد' : 'اختيار ملف صوتي جديد'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty && selectedFile != null) {
              context.read<AudioNameCubit>().editChildName(
                widget.audio.nameAudioId!,
                nameController.text,
                selectedFile!,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

class AddAudioDialog extends StatefulWidget {
  final DataFileEmpty item;

  const AddAudioDialog({super.key, required this.item});

  @override
  State<AddAudioDialog> createState() => _AddAudioDialogState();
}

class _AddAudioDialogState extends State<AddAudioDialog> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('إضافة ملف صوتي لـ "${widget.item.name}"'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('اختر ملف صوتي لإضافته'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
              );
              if (result != null) {
                setState(() {
                  selectedFile = File(result.files.single.path!);
                });
              }
            },
            icon: const Icon(Icons.file_upload),
            label: Text(
                selectedFile != null ? 'تم اختيار الملف' : 'اختيار ملف'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: selectedFile != null
              ? () {
            context.read<AudioNameCubit>().editChildName(
              widget.item.nameAudioId!,
              widget.item.name!,
              selectedFile!,
            );
            Navigator.pop(context);
          }
              : null,
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}