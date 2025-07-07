import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Problems_useCase_repo.dart';

part 'Problems_state.dart';

@injectable
class ProblemsCubit extends Cubit<ProblemsState> {
  ProblemsCubit(this._problemsUseCaseRepo) : super(ProblemsInitial());
  final ProblemsUseCaseRepo _problemsUseCaseRepo;

  static ProblemsCubit get(context) => BlocProvider.of(context);

  Future<void> fetchProblems() async {
    emit(GetProblemsLoading());
    final result = await _problemsUseCaseRepo.fetchProblems();
    switch (result) {
      case Success<GetProblemsEntity?>():
        if (!isClosed) {
          emit(GetProblemsSuccess(result.data!));
        }
        break;
      case Fail<GetProblemsEntity?>():
        if (!isClosed) {
          emit(AddProblemsFailure(result.exception));
        }
        break;
    }
  }

  Future<void> editProblem({
    required  int problemId,
    required String problemTitle,
    required String problemDescription,
  }) async {
    emit(EditProblemsLoading());

    final result = await _problemsUseCaseRepo.editProblem(
     problemId,

      problemTitle,
      problemDescription,
    );
    switch (result) {
      case Success<UpdateProblemEntity?>():
        if (!isClosed) {
          emit(EditProblemsSuccess(result.data!));
        }
        break;
      case Fail<UpdateProblemEntity?>():
        if (!isClosed) {
          emit(EditProblemsFailure(result.exception));
        }
        break;
    }
  }

  Future<void> deleteProblem(int problemId) async {
    emit(DeleteProblemsLoading());
    final result = await _problemsUseCaseRepo.deleteProblem(problemId);
    switch (result) {
      case Success<DeleteProblemEntity?>():
        if (!isClosed) {
          emit(DeleteProblemsSuccess(result.data!));
        }
        break;
      case Fail<DeleteProblemEntity?>():
        if (!isClosed) {
          emit(DeleteProblemsFailure(result.exception));
        }
        break;
    }
  }

  Future<void> addProblem({
    required String problemTitle,
    required String problemDescription,
  }) async {
    emit(AddProblemsLoading());
    final result = await _problemsUseCaseRepo.addProblem(
      problemTitle,
      problemDescription,
    );
    switch (result) {
      case Success<AddProblemEntity?>():
        if (!isClosed) {
          emit(AddProblemsSuccess(result.data!));
        }
        break;
      case Fail<AddProblemEntity?>():
        if (!isClosed) {
          emit(AddProblemsFailure(result.exception));
        }
        break;
    }
  }
}
