import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';

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
    return executeApi(() async{
      var res = await apiService.getStoryRequests();
      return res?.toEntity();

    },);
  }
}
