import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_name_audio_dto.g.dart';

@JsonSerializable()
class SearchNameAudioDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "data")
  final List<DataSearch>? data;

  SearchNameAudioDto ({
    this.status,
    this.count,
    this.data,
  });

  factory SearchNameAudioDto.fromJson(Map<String, dynamic> json) {
    return _$SearchNameAudioDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchNameAudioDtoToJson(this);
  }
  SearchNameAudioEntity toEntity() {
    return SearchNameAudioEntity(
      status: status,
      count: count,
      data: data,
    );
  }
}

@JsonSerializable()
class DataSearch {
  @JsonKey(name: "name_audio_id")
  final int? nameAudioId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "audio_file")
  final String? audioFile;
  @JsonKey(name: "created_at")
  final String? createdAt;

  DataSearch ({
    this.nameAudioId,
    this.name,
    this.audioFile,
    this.createdAt,
  });

  factory DataSearch.fromJson(Map<String, dynamic> json) {
    return _$DataSearchFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataSearchToJson(this);
  }
}


