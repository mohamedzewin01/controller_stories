import 'package:controller_stories/core/common/api_result.dart';

import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';

import '../repositories/RequestStory_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/RequestStory_useCase_repo.dart';

@Injectable(as: RequestStoryUseCaseRepo)
class RequestStoryUseCase implements RequestStoryUseCaseRepo {
  final RequestStoryRepository repository;

  RequestStoryUseCase(this.repository);

  @override
  Future<Result<GetRequestStoryEntity?>> getRequestStories() {
   return repository.getRequestStories();
  }

}
