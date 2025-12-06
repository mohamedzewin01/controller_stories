import 'package:controller_stories/features/Code/presentation/bloc/get_user_codes/get_user_codes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/Code_cubit.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {

  late CodeCubit viewModel;
  late GetUserCodesCubit getUserCodesCubit;

  @override
  void initState() {
    viewModel = getIt.get<CodeCubit>();
    getUserCodesCubit = getIt.get<GetUserCodesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('Code')),
        body: const Center(child: Text('Hello Code')),
      ),
    );
  }
}

