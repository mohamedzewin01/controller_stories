import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';

abstract class ProblemsUseCaseRepo {
  Future<Result<GetProblemsEntity?>> fetchProblems();

  Future<Result<AddProblemEntity?>> addProblem(
      String? problemTitle,
      String? problemDescription,
      );

  Future<Result<UpdateProblemEntity?>> editProblem(
      int? problemId,
      String? problemTitle,
      String? problemDescription,
      );

  Future<Result<DeleteProblemEntity?>> deleteProblem(int? problemId);
}
