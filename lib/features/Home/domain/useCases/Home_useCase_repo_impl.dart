import '../repositories/Home_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Home_useCase_repo.dart';

@Injectable(as: HomeUseCaseRepo)
class HomeUseCase implements HomeUseCaseRepo {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
