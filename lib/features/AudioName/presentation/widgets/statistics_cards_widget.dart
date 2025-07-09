// lib/features/AudioName/presentation/widgets/statistics_cards_widget.dart
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StatisticsCardsWidget extends StatelessWidget {
  const StatisticsCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioNameCubit, AudioNameState>(
      builder: (context, state) {
        int total = 0, withAudio = 0, withoutAudio = 0;

        if (state is GetAudioNameSuccess) {
          withAudio = state.getNamesAudioEntity.data?.length ?? 0;
        }
        if (state is EmptyAudioNameSuccess) {
          withoutAudio = state.audioFileEmptyEntity.data?.length ?? 0;
        }
        total = withAudio + withoutAudio;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildStatCard(
                  'المجموع',
                  total.toString(),
                  Icons.group,
                  Colors.white
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                  'مع صوت',
                  withAudio.toString(),
                  Icons.audiotrack,
                  Colors.green[100]!
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                  'بدون صوت',
                  withoutAudio.toString(),
                  Icons.music_off,
                  Colors.orange[100]!
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: color == Colors.white ? Colors.indigo[600] : Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color == Colors.white ? Colors.indigo[600] : Colors.black87,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color == Colors.white ? Colors.indigo[600] : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}