import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Code/data/models/response/create_active_code_dto.dart';
import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';

abstract class CodeDatasourceRepo {
  Future<Result<CreateActiveCodeEntity?>> createActiveCode(
    int allowedChildren,
    int durationMonths,
  );
  Future<Result<GetUserCodesEntity?>> getUserCodes(
    String filter,
    int page,
  );
}
