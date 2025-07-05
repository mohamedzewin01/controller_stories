import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_story_dto.g.dart';

@JsonSerializable()
class DeleteStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteStoryDto ({
    this.status,
    this.message,
  });

  factory DeleteStoryDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteStoryDtoToJson(this);
  }
  DeleteStoryEntity toEntity() {
    return DeleteStoryEntity(
      status: status,
      message: message,
    );
  }
}


