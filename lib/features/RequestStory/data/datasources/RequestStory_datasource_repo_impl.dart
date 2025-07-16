import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/RequestStory/data/models/request/add_replies_request.dart';

import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';

import 'RequestStory_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: RequestStoryDatasourceRepo)
class RequestStoryDatasourceRepoImpl implements RequestStoryDatasourceRepo {
  final ApiService apiService;

  RequestStoryDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<GetRequestStoryEntity?>> getRequestStories() {
    return executeApi(() async {
      var res = await apiService.getStoryRequests();
      return res?.toEntity();
    });
  }

  @override
  Future<Result<AddRepliesEntity?>> addReplies(
    int requestId,
    String replyText,
    int? attachedStoryId,
  ) {
    return executeApi(() async {
      AddRepliesRequest addRepliesRequest = AddRepliesRequest(
        requestId: requestId,
        replyText: replyText,
        attachedStoryId: attachedStoryId,
      );
      var res = await apiService.addReplies(addRepliesRequest);
      return res?.toEntity();
    });
  }

  @override
  Future<Result<GetAllStoriesEntity?>> getAllStories() {
 return executeApi(() async {
    var res = await apiService.getAllStories();
    return res?.toEntity();
 }
 );
  }
}
