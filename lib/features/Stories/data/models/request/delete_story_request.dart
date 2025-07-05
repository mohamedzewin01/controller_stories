import 'package:json_annotation/json_annotation.dart';

part 'delete_story_request.g.dart';

@JsonSerializable()
class DeleteStoryRequest {
  @JsonKey(name: "story_id")
  final int? storyId;

  DeleteStoryRequest ({
    this.storyId,
  });

  factory DeleteStoryRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteStoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteStoryRequestToJson(this);
  }
}


