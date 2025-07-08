import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_audio_name_dto.g.dart';

@JsonSerializable()
class AddAudioNameDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddAudioNameDto ({
    this.status,
    this.message,
  });

  factory AddAudioNameDto.fromJson(Map<String, dynamic> json) {
    return _$AddAudioNameDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddAudioNameDtoToJson(this);
  }
  AddAudioNameEntity toEntity() {
    return AddAudioNameEntity(
      status: status,
      message: message,
    );
  }
}


