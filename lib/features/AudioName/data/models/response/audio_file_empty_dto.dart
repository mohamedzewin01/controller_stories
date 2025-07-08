import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_file_empty_dto.g.dart';

@JsonSerializable()
class AudioFileEmptyDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "data")
  final List<DataFileEmpty>? data;

  AudioFileEmptyDto ({
    this.status,
    this.total,
    this.data,
  });

  factory AudioFileEmptyDto.fromJson(Map<String, dynamic> json) {
    return _$AudioFileEmptyDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AudioFileEmptyDtoToJson(this);
  }
  AudioFileEmptyEntity toEntity() {
    return AudioFileEmptyEntity(
      status: status,
      total: total,
      data: data,
    );
  }
}

@JsonSerializable()
class DataFileEmpty {
  @JsonKey(name: "name_audio_id")
  final int? nameAudioId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "audio_file")
  final dynamic? audioFile;
  @JsonKey(name: "created_at")
  final String? createdAt;

  DataFileEmpty ({
    this.nameAudioId,
    this.name,
    this.audioFile,
    this.createdAt,
  });

  factory DataFileEmpty.fromJson(Map<String, dynamic> json) {
    return _$DataFileEmptyFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataFileEmptyToJson(this);
  }

}


