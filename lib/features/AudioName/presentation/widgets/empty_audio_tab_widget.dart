// lib/features/AudioName/presentation/widgets/empty_audio_tab_widget.dart
import 'package:controller_stories/features/AudioName/data/models/response/audio_file_empty_dto.dart';
import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/empty_state_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/error_state_widget.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'empty_audio_card_widget.dart';

class EmptyAudioTabWidget extends StatelessWidget {
  const EmptyAudioTabWidget({super.key,  required this.viewModel});
final AudioNameCubit viewModel ;
  @override
  Widget build(BuildContext context) {
    viewModel.nameAudioEmpty();
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocBuilder<AudioNameCubit, AudioNameState>(
        builder: (context, state) {
          if (state is EmptyAudioNameLoading) {
            return const LoadingStateWidget(
                message: 'جاري تحميل الأسماء بدون ملفات صوتية...');
          }

          if (state is EmptyAudioNameSuccess) {
            final emptyList = state.audioFileEmptyEntity.data ?? [];

            if (emptyList.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.check_circle,
                title: 'ممتاز! 🎉',
                subtitle: 'جميع الأسماء لديها ملفات صوتية',
                iconColor: Colors.green,
              );
            }

            return _buildEmptyAudioList(emptyList,viewModel);
          }

          if (state is EmptyAudioNameFailure) {
            return ErrorStateWidget(
              message: 'خطأ في تحميل البيانات',
              onRetry: () => context.read<AudioNameCubit>().nameAudioEmpty(),
            );
          }

          return const EmptyStateWidget(
            icon: Icons.info,
            title: 'لا توجد بيانات',
            subtitle: 'لم يتم تحميل البيانات بعد',
          );
        },
      ),
    );
  }

  Widget _buildEmptyAudioList(List<DataFileEmpty> emptyList, AudioNameCubit viewModel) {
    return Column(
      children: [
        // Header Info
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.orange[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'يوجد ${emptyList.length} اسم بحاجة إلى ملفات صوتية',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: emptyList.length,
            itemBuilder: (context, index) {
              return EmptyAudioCardWidget(item: emptyList[index],viewModel: viewModel,);
            },
          ),
        ),
      ],
    );
  }
}