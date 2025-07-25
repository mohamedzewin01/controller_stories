// // lib/features/AudioName/presentation/widgets/all_names_tab_widget.dart
// import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
// import 'package:controller_stories/features/AudioName/data/models/response/search_name_audio_dto.dart';
// import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
// import 'package:controller_stories/features/AudioName/presentation/widgets/empty_state_widget.dart';
// import 'package:controller_stories/features/AudioName/presentation/widgets/error_state_widget.dart';
// import 'package:controller_stories/features/AudioName/presentation/widgets/loading_state_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'search_bar_widget.dart';
// import 'audio_card_widget.dart';
//
//
// class AllNamesTabWidget extends StatelessWidget {
//   final AudioPlayer audioPlayer;
//   final String? currentPlayingId;
//   final bool isPlaying;
//   final Duration duration;
//   final Duration position;
//   final Function(String, String) onPlayPause;
//
//   const AllNamesTabWidget({
//     super.key,
//     required this.audioPlayer,
//     required this.currentPlayingId,
//     required this.isPlaying,
//     required this.duration,
//     required this.position,
//     required this.onPlayPause,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     AudioNameCubit.get(context).fetchNamesAudio();
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<AudioNameCubit>().fetchNamesAudio();
//       },
//       child: Column(
//         children: [
//           SearchBarWidget(
//             onSearch: (query) {
//               if (query.isNotEmpty) {
//                 context.read<AudioNameCubit>().searchAudioName(query);
//               } else {
//                 context.read<AudioNameCubit>().fetchNamesAudio();
//               }
//             },
//           ),
//           Expanded(
//             child: BlocBuilder<AudioNameCubit, AudioNameState>(
//               builder: (context, state) {
//                 if (state is GetAudioNameLoading || state is SearchNameLoading) {
//                   return const LoadingStateWidget();
//                 }
//
//                 if (state is GetAudioNameSuccess) {
//                   return _buildAudioList(
//                       context,
//                       state.getNamesAudioEntity.data ?? []
//                   );
//                 }
//
//                 if (state is SearchNameSuccess) {
//                   return _buildSearchResults(
//                       context,
//                       state.searchNameAudioEntity.data ?? []
//                   );
//                 }
//
//                 if (state is GetAudioNameFailure || state is SearchNameFailure) {
//                   return ErrorStateWidget(
//                     onRetry: () => context.read<AudioNameCubit>().fetchNamesAudio(),
//                   );
//                 }
//
//                 return EmptyStateWidget(
//                   icon: Icons.music_note,
//                   title: 'لا توجد أسماء',
//                   subtitle: 'ابدأ بإضافة أسماء جديدة',
//                   actionText: 'إضافة اسم جديد',
//                   onAction: () {
//                     // Navigate to add tab
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAudioList(BuildContext context, List<DataAudio> audioList) {
//     if (audioList.isEmpty) {
//       return EmptyStateWidget(
//         icon: Icons.music_note,
//         title: 'لا توجد أسماء',
//         subtitle: 'ابدأ بإضافة أسماء جديدة',
//         actionText: 'إضافة اسم جديد',
//         onAction: () {
//           // Navigate to add tab
//         },
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: audioList.length,
//       itemBuilder: (context, index) {
//         final audio = audioList[index];
//         return AudioCardWidget(
//           audio: audio,
//           isCurrentPlaying: currentPlayingId == audio.nameAudioId.toString(),
//           isPlaying: isPlaying,
//           duration: duration,
//           position: position,
//           onPlayPause: onPlayPause,
//         );
//       },
//     );
//   }
//
//   Widget _buildSearchResults(BuildContext context, List<DataSearch> searchResults) {
//     if (searchResults.isEmpty) {
//       return const EmptyStateWidget(
//         icon: Icons.search_off,
//         title: 'لم يتم العثور على نتائج',
//         subtitle: 'جرب البحث بكلمات مختلفة',
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: searchResults.length,
//       itemBuilder: (context, index) {
//         final search = searchResults[index];
//         final audio = DataAudio(
//           nameAudioId: search.nameAudioId,
//           name: search.name,
//           audioFile: search.audioFile,
//           createdAt: search.createdAt,
//         );
//
//         return AudioCardWidget(
//           audio: audio,
//           isCurrentPlaying: currentPlayingId == audio.nameAudioId.toString(),
//           isPlaying: isPlaying,
//           duration: duration,
//           position: position,
//           onPlayPause: onPlayPause,
//         );
//       },
//     );
//   }
// }
// }
// lib/features/AudioName/presentation/widgets/all_names_tab_widget.dart
import 'package:controller_stories/features/AudioName/data/models/response/get_names_audio_dto.dart';
import 'package:controller_stories/features/AudioName/data/models/response/search_name_audio_dto.dart';
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/empty_state_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/error_state_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'search_bar_widget.dart';
import 'audio_card_widget.dart';

class AllNamesTabWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String? currentPlayingId;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final Function(String, String) onPlayPause;
  final AudioNameCubit viewModel;

  const AllNamesTabWidget({
    super.key,
    required this.audioPlayer,
    required this.currentPlayingId,
    required this.isPlaying,
    required this.duration,
    required this.position,
    required this.onPlayPause,
    required this.viewModel,
  });

  @override
  State<AllNamesTabWidget> createState() => _AllNamesTabWidgetState();
}

class _AllNamesTabWidgetState extends State<AllNamesTabWidget> {
  bool _isSearchMode = false;
  String _currentQuery = '';
  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();
    // تحميل البيانات مرة واحدة عند بناء الويدجت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLoadedInitialData) {
        _loadInitialData();
      }
    });
  }

  void _loadInitialData() {
    try {
      widget.viewModel.fetchNamesAudio();
      _hasLoadedInitialData = true;
    } catch (e) {
      _showError('خطأ في تحميل البيانات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        try {
          if (_isSearchMode && _currentQuery.isNotEmpty) {
            await widget.viewModel.searchAudioName(_currentQuery);
          } else {
            await widget.viewModel.fetchNamesAudio();
          }
        } catch (e) {
          _showError('خطأ في تحديث البيانات');
        }
      },
      child: Column(
        children: [
          SearchBarWidget(
            onSearch: _handleSearch,
            onClear: _handleClearSearch,
          ),
          Expanded(
            child: BlocBuilder<AudioNameCubit, AudioNameState>(
              builder: (context, state) => _buildContent(context, state, widget.viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AudioNameState state, AudioNameCubit viewModel) {
    // حالات التحميل
    if (state is GetAudioNameLoading || state is SearchNameLoading) {
      return LoadingStateWidget(
        message: _isSearchMode ? 'جاري البحث...' : 'جاري تحميل الأسماء...',
      );
    }

    // حالات النجاح
    if (state is GetAudioNameSuccess && !_isSearchMode) {
      return _buildAudioList(
        context,
        state.getNamesAudioEntity.data ?? [],
        isSearchResult: false,
        viewModel: viewModel,
      );
    }

    if (state is SearchNameSuccess && _isSearchMode) {
      return _buildSearchResults(
        context,
        state.searchNameAudioEntity.data ?? [],
        viewModel,
      );
    }

    // حالات الخطأ
    if (state is GetAudioNameFailure && !_isSearchMode) {
      return ErrorStateWidget(
        message: 'خطأ في تحميل البيانات',
        onRetry: () => _retryLoadData(),
      );
    }

    if (state is SearchNameFailure && _isSearchMode) {
      return ErrorStateWidget(
        message: 'خطأ في البحث',
        onRetry: () => _retrySearch(),
      );
    }

    // حالة عدم وجود بيانات
    return EmptyStateWidget(
      icon: Icons.music_note,
      title: 'لا توجد أسماء',
      subtitle: 'ابدأ بإضافة أسماء جديدة',
      actionText: 'إضافة اسم جديد',
      onAction: () {
        // يمكن إضافة navigation للتاب الخاص بالإضافة
      },
    );
  }

  Widget _buildAudioList(
      BuildContext context,
      List<DataAudio> audioList, {
        bool isSearchResult = false,
        required AudioNameCubit viewModel,
      }) {
    if (audioList.isEmpty) {
      return EmptyStateWidget(
        icon: isSearchResult ? Icons.search_off : Icons.music_note,
        title: isSearchResult ? 'لم يتم العثور على نتائج' : 'لا توجد أسماء',
        subtitle: isSearchResult
            ? 'جرب البحث بكلمات مختلفة'
            : 'ابدأ بإضافة أسماء جديدة',
        actionText: isSearchResult ? null : 'إضافة اسم جديد',
        onAction: isSearchResult ? null : () {
          // Navigation to add tab
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: audioList.length,
      itemBuilder: (context, index) {
        final audio = audioList[index];
        return AudioCardWidget(
          audio: audio,
          isCurrentPlaying: widget.currentPlayingId == audio.nameAudioId.toString(),
          isPlaying: widget.isPlaying,
          duration: widget.duration,
          position: widget.position,
          onPlayPause: (audioUrl, id) => _handlePlayPause(audioUrl, id),
          viewModel: viewModel,
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, List<DataSearch> searchResults, AudioNameCubit viewModel) {
    if (searchResults.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'لم يتم العثور على نتائج',
        subtitle: 'جرب البحث بكلمات مختلفة أو امسح البحث لعرض جميع الأسماء',
        actionText: 'مسح البحث',
        onAction: _handleClearSearch,
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

        return AudioCardWidget(
          audio: audio,
          isCurrentPlaying: widget.currentPlayingId == audio.nameAudioId.toString(),
          isPlaying: widget.isPlaying,
          duration: widget.duration,
          position: widget.position,
          onPlayPause: (audioUrl, id) => _handlePlayPause(audioUrl, id),
          viewModel: viewModel,
        );
      },
    );
  }

  // معالجة تشغيل الصوت مع معالجة الأخطاء
  Future<void> _handlePlayPause(String audioUrl, String id) async {
    try {
      if (audioUrl.isEmpty) {
        _showError('لا يوجد ملف صوتي');
        return;
      }
      await widget.onPlayPause(audioUrl, id);
    } catch (e) {
      _showError('خطأ في تشغيل الملف الصوتي');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _currentQuery = query;
      _isSearchMode = query.isNotEmpty;
    });

    try {
      if (query.trim().isEmpty) {
        widget.viewModel.fetchNamesAudio();
      } else {
        widget.viewModel.searchAudioName(query.trim());
      }
    } catch (e) {
      _showError('خطأ في البحث');
    }
  }

  void _handleClearSearch() {
    setState(() {
      _isSearchMode = false;
      _currentQuery = '';
    });

    try {
      widget.viewModel.fetchNamesAudio();
    } catch (e) {
      _showError('خطأ في تحميل البيانات');
    }
  }

  void _retryLoadData() {
    try {
      widget.viewModel.fetchNamesAudio();
    } catch (e) {
      _showError('خطأ في إعادة تحميل البيانات');
    }
  }

  void _retrySearch() {
    try {
      if (_currentQuery.isNotEmpty) {
        widget.viewModel.searchAudioName(_currentQuery);
      }
    } catch (e) {
      _showError('خطأ في إعادة البحث');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}