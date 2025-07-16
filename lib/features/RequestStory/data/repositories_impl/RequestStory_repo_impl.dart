import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/RequestStory/data/datasources/RequestStory_datasource_repo.dart';
import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/RequestStory_repository.dart';

@Injectable(as: RequestStoryRepository)
class RequestStoryRepositoryImpl implements RequestStoryRepository {
  final RequestStoryDatasourceRepo requestStoryDatasourceRepo;
  RequestStoryRepositoryImpl(this.requestStoryDatasourceRepo);

  @override
  Future<Result<GetRequestStoryEntity?>> getRequestStories() {
return requestStoryDatasourceRepo.getRequestStories();
  }

  @override
  Future<Result<AddRepliesEntity?>> addReplies(int requestId, String replyText, int? attachedStoryId) {
  return requestStoryDatasourceRepo.addReplies(requestId, replyText, attachedStoryId);
  }

  @override
  Future<Result<GetAllStoriesEntity?>> getAllStories() {
  return requestStoryDatasourceRepo.getAllStories();
  }

  // implementation
}
