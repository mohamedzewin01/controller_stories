import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Code/data/datasources/Code_datasource_repo.dart';
import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/Code_repository.dart';

@Injectable(as: CodeRepository)
class CodeRepositoryImpl implements CodeRepository {
  final CodeDatasourceRepo codeDatasourceRepo;

  CodeRepositoryImpl(this.codeDatasourceRepo);

  @override
  Future<Result<CreateActiveCodeEntity?>> createActiveCode(int allowedChildren,
      int durationMonths) {
    return codeDatasourceRepo.createActiveCode(allowedChildren, durationMonths);
  }

  @override
  Future<Result<GetUserCodesEntity?>> getUserCodes(String filter, int page) {
    return codeDatasourceRepo.getUserCodes(filter, page);
  }
}
