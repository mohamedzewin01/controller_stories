import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Problems_useCase_repo.dart';

part 'Problems_state.dart';

@injectable
class ProblemsCubit extends Cubit<ProblemsState> {
  ProblemsCubit(this._problemsUseCaseRepo) : super(ProblemsInitial());
  final ProblemsUseCaseRepo _problemsUseCaseRepo;
}
