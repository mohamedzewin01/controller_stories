import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Code/data/models/request/create_active_code_request.dart';
import 'package:controller_stories/features/Code/data/models/request/get_user_codes_request.dart';

import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';

import 'Code_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: CodeDatasourceRepo)
class CodeDatasourceRepoImpl implements CodeDatasourceRepo {
  final ApiService apiService;

  CodeDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<CreateActiveCodeEntity?>> createActiveCode(
    int allowedChildren,
    int durationMonths,
  ) {
    return executeApi(() async {
      final response = await apiService.createActiveCode(
        CreateActiveCodeRequest(
          allowedChildren: allowedChildren,
          durationMonths: durationMonths,
        ),
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<GetUserCodesEntity?>> getUserCodes(String filter, int page) {
    return executeApi(() async {
      final response = await apiService.getUserCodes(
        GetUserCodesRequest(
          filter: filter,
          page: page,
        ),
      );
      return response?.toEntity();
    });
  }
}
