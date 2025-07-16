import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';

abstract class RequestStoryUseCaseRepo {
  Future<Result<GetRequestStoryEntity?>>getRequestStories();
  Future<Result<AddRepliesEntity?>>addReplies(
      {required int requestId,required String replyText, int? attachedStoryId});
  Future<Result<GetAllStoriesEntity?>>getAllStories();
}
