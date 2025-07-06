import 'package:controller_stories/features/Clips/domain/entities/add_clip_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_clips_dto.g.dart';

@JsonSerializable()
class AddClipsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddClipsDto ({
    this.status,
    this.message,
  });

  factory AddClipsDto.fromJson(Map<String, dynamic> json) {
    return _$AddClipsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddClipsDtoToJson(this);
  }
  AddClipsEntity toEntity() {
    return AddClipsEntity(
      status: status,
      message: message,
    );
  }
}


