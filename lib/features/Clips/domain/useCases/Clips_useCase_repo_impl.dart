import '../repositories/Clips_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Clips_useCase_repo.dart';

@Injectable(as: ClipsUseCaseRepo)
class ClipsUseCase implements ClipsUseCaseRepo {
  final ClipsRepository repository;

  ClipsUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
