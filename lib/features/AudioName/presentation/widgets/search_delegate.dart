import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/AudioName_cubit.dart';

class AudioNameSearchDelegate extends SearchDelegate<String> {
  final AudioNameCubit cubit;

  AudioNameSearchDelegate(this.cubit);

  @override
  String get searchFieldLabel => 'البحث عن اسم...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      cubit.searchAudioName(query);
    }

    return BlocBuilder<AudioNameCubit, AudioNameState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is SearchNameLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchNameSuccess) {
          final results = state.searchNameAudioEntity.data ?? [];

          if (results.isEmpty) {
            return const Center(
              child: Text('لا توجد نتائج للبحث'),
            );
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(result.name ?? ''),
                subtitle: Text(result.createdAt ?? ''),
                onTap: () {
                  close(context, result.name ?? '');
                },
              );
            },
          );
        }

        return const Center(child: Text('ابدأ البحث'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اقتراحات البحث:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('أحمد', context),
              _buildSuggestionChip('فاطمة', context),
              _buildSuggestionChip('محمد', context),
              _buildSuggestionChip('عائشة', context),
              _buildSuggestionChip('علي', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion, BuildContext context) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        query = suggestion;
        showResults(context);
      },
    );
  }
}