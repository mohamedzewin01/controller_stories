import 'package:controller_stories/core/common/api_result.dart';

import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';

import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';

import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';

import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';

import '../repositories/Problems_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Problems_useCase_repo.dart';

@Injectable(as: ProblemsUseCaseRepo)
class ProblemsUseCase implements ProblemsUseCaseRepo {
  final ProblemsRepository repository;

  ProblemsUseCase(this.repository);

  @override
  Future<Result<AddProblemEntity?>> addProblem(
    String? problemTitle,
    String? problemDescription,
  ) {
    return repository.addProblem(problemTitle, problemDescription);
  }

  @override
  Future<Result<DeleteProblemEntity?>> deleteProblem(int? problemId) {
    return repository.deleteProblem(problemId);
  }

  @override
  Future<Result<UpdateProblemEntity?>> editProblem(
    String? problemTitle,
    String? problemDescription,
  ) {
    return repository.editProblem(problemTitle, problemDescription);
  }

  @override
  Future<Result<GetProblemsEntity?>> fetchProblems() {
    return repository.fetchProblems();
  }
}
