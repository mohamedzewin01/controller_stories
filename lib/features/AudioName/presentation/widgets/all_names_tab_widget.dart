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


class AllNamesTabWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String? currentPlayingId;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final Function(String, String) onPlayPause;

  const AllNamesTabWidget({
    super.key,
    required this.audioPlayer,
    required this.currentPlayingId,
    required this.isPlaying,
    required this.duration,
    required this.position,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    AudioNameCubit.get(context).fetchNamesAudio();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AudioNameCubit>().fetchNamesAudio();
      },
      child: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              if (query.isNotEmpty) {
                context.read<AudioNameCubit>().searchAudioName(query);
              } else {
                context.read<AudioNameCubit>().fetchNamesAudio();
              }
            },
          ),
          Expanded(
            child: BlocBuilder<AudioNameCubit, AudioNameState>(
              builder: (context, state) {
                if (state is GetAudioNameLoading || state is SearchNameLoading) {
                  return const LoadingStateWidget();
                }

                if (state is GetAudioNameSuccess) {
                  return _buildAudioList(
                      context,
                      state.getNamesAudioEntity.data ?? []
                  );
                }

                if (state is SearchNameSuccess) {
                  return _buildSearchResults(
                      context,
                      state.searchNameAudioEntity.data ?? []
                  );
                }

                if (state is GetAudioNameFailure || state is SearchNameFailure) {
                  return ErrorStateWidget(
                    onRetry: () => context.read<AudioNameCubit>().fetchNamesAudio(),
                  );
                }

                return EmptyStateWidget(
                  icon: Icons.music_note,
                  title: 'لا توجد أسماء',
                  subtitle: 'ابدأ بإضافة أسماء جديدة',
                  actionText: 'إضافة اسم جديد',
                  onAction: () {
                    // Navigate to add tab
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioList(BuildContext context, List<DataAudio> audioList) {
    if (audioList.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.music_note,
        title: 'لا توجد أسماء',
        subtitle: 'ابدأ بإضافة أسماء جديدة',
        actionText: 'إضافة اسم جديد',
        onAction: () {
          // Navigate to add tab
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
          isCurrentPlaying: currentPlayingId == audio.nameAudioId.toString(),
          isPlaying: isPlaying,
          duration: duration,
          position: position,
          onPlayPause: onPlayPause,
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, List<DataSearch> searchResults) {
    if (searchResults.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'لم يتم العثور على نتائج',
        subtitle: 'جرب البحث بكلمات مختلفة',
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
          isCurrentPlaying: currentPlayingId == audio.nameAudioId.toString(),
          isPlaying: isPlaying,
          duration: duration,
          position: position,
          onPlayPause: onPlayPause,
        );
      },
    );
  }
}