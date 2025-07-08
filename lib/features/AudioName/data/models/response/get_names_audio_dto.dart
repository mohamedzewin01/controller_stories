import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_names_audio_dto.g.dart';

@JsonSerializable()
class GetNamesAudioDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "data")
  final List<DataAudio>? data;

  GetNamesAudioDto ({
    this.status,
    this.currentPage,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });

  factory GetNamesAudioDto.fromJson(Map<String, dynamic> json) {
    return _$GetNamesAudioDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetNamesAudioDtoToJson(this);
  }
  GetNamesAudioEntity toEntity() {
    return GetNamesAudioEntity(
      status: status,
      currentPage: currentPage,
      perPage: perPage,
      total: total,
        totalPages: totalPages,
      data: data,
    );
  }
}

@JsonSerializable()
class DataAudio {
  @JsonKey(name: "name_audio_id")
  final int? nameAudioId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "audio_file")
  final String? audioFile;
  @JsonKey(name: "created_at")
  final String? createdAt;

  DataAudio ({
    this.nameAudioId,
    this.name,
    this.audioFile,
    this.createdAt,
  });

  factory DataAudio.fromJson(Map<String, dynamic> json) {
    return _$DataAudioFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataAudioToJson(this);
  }
}


