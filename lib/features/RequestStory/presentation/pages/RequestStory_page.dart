import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/RequestStory_cubit.dart';

class RequestStoryPage extends StatefulWidget {
  const RequestStoryPage({super.key});

  @override
  State<RequestStoryPage> createState() => _RequestStoryPageState();
}

class _RequestStoryPageState extends State<RequestStoryPage> {

  late RequestStoryCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<RequestStoryCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('RequestStory')),
        body: const Center(child: Text('Hello RequestStory')),
      ),
    );
  }
}

