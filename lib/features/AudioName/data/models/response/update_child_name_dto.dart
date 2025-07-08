import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_child_name_dto.g.dart';

@JsonSerializable()
class UpdateChildNameDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  UpdateChildNameDto ({
    this.status,
    this.message,
  });

  factory UpdateChildNameDto.fromJson(Map<String, dynamic> json) {
    return _$UpdateChildNameDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateChildNameDtoToJson(this);
  }

  UpdateChildNameEntity toEntity() {
    return UpdateChildNameEntity(
      status: status,
      message: message,
    );
  }
}


