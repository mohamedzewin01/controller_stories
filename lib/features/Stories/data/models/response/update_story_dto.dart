import 'package:controller_stories/features/Stories/domain/entities/update_story.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_story_dto.g.dart';

@JsonSerializable()
class UpdateStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  UpdateStoryDto ({
    this.status,
    this.message,
  });

  factory UpdateStoryDto.fromJson(Map<String, dynamic> json) {
    return _$UpdateStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateStoryDtoToJson(this);
  }
  UpdateStoryEntity toEntity() {
    return UpdateStoryEntity(
      status: status,
      message: message,
    );
  }
}


