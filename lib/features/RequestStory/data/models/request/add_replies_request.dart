import 'package:json_annotation/json_annotation.dart';

part 'add_replies_request.g.dart';

@JsonSerializable()
class AddRepliesRequest {
  @JsonKey(name: "request_id")
  final int? requestId;
  @JsonKey(name: "reply_text")
  final String? replyText;
  @JsonKey(name: "attached_story_id")
  final int? attachedStoryId;

  AddRepliesRequest ({
    this.requestId,
    this.replyText,
    this.attachedStoryId,
  });

  factory AddRepliesRequest.fromJson(Map<String, dynamic> json) {
    return _$AddRepliesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddRepliesRequestToJson(this);
  }
}


