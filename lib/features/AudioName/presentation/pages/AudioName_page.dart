import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/AudioName_cubit.dart';

class AudioNamePage extends StatefulWidget {
  const AudioNamePage({super.key});

  @override
  State<AudioNamePage> createState() => _AudioNamePageState();
}

class _AudioNamePageState extends State<AudioNamePage> {

  late AudioNameCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AudioNameCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('AudioName')),
        body: const Center(child: Text('Hello AudioName')),
      ),
    );
  }
}

