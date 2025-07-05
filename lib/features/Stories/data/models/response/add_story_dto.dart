import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_story_dto.g.dart';

@JsonSerializable()
class AddStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddStoryDto ({
    this.status,
    this.message,
  });

  factory AddStoryDto.fromJson(Map<String, dynamic> json) {
    return _$AddStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddStoryDtoToJson(this);
  }
  AddStoryEntity toEntity() {
    return AddStoryEntity(
      status: status,
      message: message,
    );
  }
}


