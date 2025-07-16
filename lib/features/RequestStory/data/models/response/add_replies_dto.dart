import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_replies_dto.g.dart';

@JsonSerializable()
class AddRepliesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "reply_id")
  final String? replyId;

  AddRepliesDto ({
    this.status,
    this.message,
    this.replyId,
  });

  factory AddRepliesDto.fromJson(Map<String, dynamic> json) {
    return _$AddRepliesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddRepliesDtoToJson(this);
  }
  AddRepliesEntity toEntity() {
    return AddRepliesEntity(
      status: status,
      message: message,
      replyId: replyId,
    );
  }
}


