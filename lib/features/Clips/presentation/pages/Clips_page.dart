import 'package:controller_stories/core/api/api_constants.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/fetch_clips_dto.dart';
import '../bloc/Clips_cubit.dart';
import '../widgets/clip_item_widget.dart';
import '../widgets/add_clip_dialog.dart';
import '../widgets/edit_clip_dialog.dart';

class ClipsPage extends StatefulWidget {
  final int storyId;
  final String storyTitle;

  const ClipsPage({super.key, required this.storyId, required this.storyTitle});

  @override
  State<ClipsPage> createState() => _ClipsPageState();
}

class _ClipsPageState extends State<ClipsPage> {
  late ClipsCubit viewModel;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentPlayingIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    viewModel = getIt.get<ClipsCubit>();
    _loadClips();
    _setupAudioPlayer();
    super.initState();
  }

  void _loadClips() {
    viewModel.fetchClips(widget.storyId);
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _currentPlayingIndex = null;
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioUrl, int index) async {
    String audioFilePath = "${ApiConstants.urlAudio}$audioUrl";

    try {
      if (_currentPlayingIndex == index && _isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(audioFilePath));
        setState(() {
          _currentPlayingIndex = index;
        });
      }
    } catch (e) {
      print('خطأ في تشغيل الصوت: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تشغيل الصوت: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddClipDialog() {
    showDialog(
      context: context,
      builder: (context) => AddClipDialog(
        storyId: widget.storyId,
        onClipAdded: () {
          Navigator.pop(context);
          _loadClips();
        },
      ),
    );
  }

  void _showEditClipDialog(Clips clip) {
    showDialog(
      context: context,
      builder: (context) => EditClipDialog(
        clip: clip,
        storyId: widget.storyId,
        onClipUpdated: () {
          Navigator.pop(context);
          _loadClips();
        },
      ),
    );
  }

  void _deleteClip(int clipGroupId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المقطع؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteClip(clipGroupId, widget.storyId).then((value) {
                viewModel.fetchClips(widget.storyId);
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildAppBar(),
        body: BlocConsumer<ClipsCubit, ClipsState>(
          listener: (context, state) {
            if (state is ClipsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.exception.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ClipsDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ClipsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
                ),
              );
            }

            if (state is ClipsFetchSuccess) {
              return _buildClipsContent(state.clipsData);
            }

            return _buildEmptyState();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddClipDialog,
          backgroundColor: const Color(0xFF6C5CE7),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مقاطع القصة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.storyTitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF6C5CE7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadClips,
        ),
      ],
    );
  }

  Widget _buildClipsContent(FetchClipsEntity clipsData) {
    if (clipsData.clips == null || clipsData.clips!.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => _loadClips(),
      color: const Color(0xFF6C5CE7),
      child: Column(
        children: [
          _buildHeader(clipsData.count ?? 0),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clipsData.clips!.length,
              onReorder: (oldIndex, newIndex) {
                viewModel.reorderClips(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final clip = clipsData.clips![index];
                return ClipItemWidget(
                  key: ValueKey(clip.clipGroupId),
                  clip: clip,
                  index: index,
                  isPlaying: _currentPlayingIndex == index && _isPlaying,
                  onPlay: () => _playAudio(clip.audioUrl ?? '', index),
                  onEdit: () => _showEditClipDialog(clip),
                  onDelete: () => _deleteClip(clip.clipGroupId ?? 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int clipsCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.movie_creation_outlined,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إجمالي المقاطع',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '$clipsCount مقطع',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'قابل للترتيب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مقاطع في هذه القصة',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على زر + لإضافة مقطع جديد',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddClipDialog,
            icon: const Icon(Icons.add),
            label: const Text('إضافة مقطع جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
