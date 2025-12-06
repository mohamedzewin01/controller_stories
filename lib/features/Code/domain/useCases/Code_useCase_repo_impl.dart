import 'package:controller_stories/core/common/api_result.dart';

import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';

import '../repositories/Code_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Code_useCase_repo.dart';

@Injectable(as: CodeUseCaseRepo)
class CodeUseCase implements CodeUseCaseRepo {
  final CodeRepository repository;

  CodeUseCase(this.repository);

  @override
  Future<Result<CreateActiveCodeEntity?>> createActiveCode(int allowedChildren, int durationMonths) {
    return repository.createActiveCode(allowedChildren, durationMonths);
  }

  @override
  Future<Result<GetUserCodesEntity?>> getUserCodes(String filter, int page) {
  return repository.getUserCodes(filter, page);
  }



}
