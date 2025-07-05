import '../repositories/Stories_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Stories_useCase_repo.dart';

@Injectable(as: StoriesUseCaseRepo)
class StoriesUseCase implements StoriesUseCaseRepo {
  final StoriesRepository repository;

  StoriesUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
