import '../repositories/AudioName_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/AudioName_useCase_repo.dart';

@Injectable(as: AudioNameUseCaseRepo)
class AudioNameUseCase implements AudioNameUseCaseRepo {
  final AudioNameRepository repository;

  AudioNameUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
