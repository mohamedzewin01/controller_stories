import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_audio_name_dto.g.dart';

@JsonSerializable()
class DeleteAudioNameDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteAudioNameDto ({
    this.status,
    this.message,
  });

  factory DeleteAudioNameDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteAudioNameDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteAudioNameDtoToJson(this);
  }
  DeleteAudioNameEntity toEntity() {
    return DeleteAudioNameEntity(
      status: status,
      message: message,
    );
  }
}


