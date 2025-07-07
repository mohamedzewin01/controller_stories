import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Problems/data/datasources/Problems_datasource_repo.dart';
import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/Problems_repository.dart';

@Injectable(as: ProblemsRepository)
class ProblemsRepositoryImpl implements ProblemsRepository {
  final ProblemsDatasourceRepo _problemsDatasourceRepo;

  ProblemsRepositoryImpl(this._problemsDatasourceRepo);

  @override
  Future<Result<AddProblemEntity?>> addProblem(String? problemTitle, String? problemDescription) {
   return _problemsDatasourceRepo.addProblem(problemTitle, problemDescription);
  }

  @override
  Future<Result<DeleteProblemEntity?>> deleteProblem(int? problemId) {
 return _problemsDatasourceRepo.deleteProblem(problemId);
  }

  @override
  Future<Result<UpdateProblemEntity?>> editProblem(String? problemTitle, String? problemDescription) {
   return _problemsDatasourceRepo.editProblem(problemTitle, problemDescription);
  }

  @override
  Future<Result<GetProblemsEntity?>> fetchProblems() {
   return _problemsDatasourceRepo.fetchProblems();
  }
}
