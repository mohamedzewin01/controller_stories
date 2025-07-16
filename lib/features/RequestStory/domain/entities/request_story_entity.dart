
import 'package:controller_stories/features/RequestStory/data/models/response/get_request_story_dto.dart';

class GetRequestStoryEntity {

  final String? status;

  final String? message;

  final List<DataRequest>? data;

  GetRequestStoryEntity ({
    this.status,
    this.message,
    this.data,
  });


}