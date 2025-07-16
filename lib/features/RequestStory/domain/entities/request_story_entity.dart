
import 'package:controller_stories/features/RequestStory/data/models/response/get_all_stories_dto.dart';
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

class AddRepliesEntity {

  final String? status;

  final String? message;

  final String? replyId;

  AddRepliesEntity ({
    this.status,
    this.message,
    this.replyId,
  });


}

class GetAllStoriesEntity {

  final String? status;

  final String? message;

  final List<Data>? data;

  GetAllStoriesEntity ({
    this.status,
    this.message,
    this.data,
  });


}