import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/AudioName_useCase_repo.dart';

part 'AudioName_state.dart';

@injectable
class AudioNameCubit extends Cubit<AudioNameState> {
  AudioNameCubit(this._audionameUseCaseRepo) : super(AudioNameInitial());
  final AudioNameUseCaseRepo _audionameUseCaseRepo;
}
