import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Clips_useCase_repo.dart';

part 'Clips_state.dart';

@injectable
class ClipsCubit extends Cubit<ClipsState> {
  ClipsCubit(this._clipsUseCaseRepo) : super(ClipsInitial());
  final ClipsUseCaseRepo _clipsUseCaseRepo;
}
