import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Problems/data/models/request/add_problem_request.dart';
import 'package:controller_stories/features/Problems/data/models/request/delete_problem_request.dart';
import 'package:controller_stories/features/Problems/data/models/request/update_problem_request.dart';
import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';
import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';
import 'Problems_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: ProblemsDatasourceRepo)
class ProblemsDatasourceRepoImpl implements ProblemsDatasourceRepo {
  final ApiService apiService;

  ProblemsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetProblemsEntity?>> fetchProblems() {
    return executeApi(() async {
      var response = await apiService.getProblems();
      return response?.toEntity();
    });
  }

  @override
  Future<Result<AddProblemEntity?>> addProblem(
    String? problemTitle,
    String? problemDescription,
  ) {
    return executeApi(() async {
      AddProblemRequest addProblemRequest = AddProblemRequest(
        problemDescription: problemDescription,
        problemTitle: problemTitle,
      );
      var response = await apiService.addProblem(addProblemRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<UpdateProblemEntity?>> editProblem(
      int? problemId,
    String? problemTitle,
    String? problemDescription,
  ) {
    return executeApi(() async {
      UpdateProblemRequest updateProblemRequest = UpdateProblemRequest(
        problemId:problemId ,
        problemDescription: problemDescription,
        problemTitle: problemTitle,
      );
      var response = await apiService.updateProblem(updateProblemRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<DeleteProblemEntity?>> deleteProblem(int? problemId) {
    return executeApi(() async {
      DeleteProblemRequest deleteProblemRequest = DeleteProblemRequest(
        problemId: problemId,
      );
      var response = await apiService.deleteProblem(deleteProblemRequest);
      return response?.toEntity();
    });
  }
}
