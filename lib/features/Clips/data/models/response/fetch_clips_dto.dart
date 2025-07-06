import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fetch_clips_dto.g.dart';

@JsonSerializable()
class FetchClipsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "clips")
  final List<Clips>? clips;

  FetchClipsDto ({
    this.status,
    this.message,
    this.count,
    this.clips,
  });

  factory FetchClipsDto.fromJson(Map<String, dynamic> json) {
    return _$FetchClipsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FetchClipsDtoToJson(this);
  }
  FetchClipsEntity toEntity() {
    return FetchClipsEntity(
      status: status,
      message: message,
      count: count,
      clips: clips,
    );
  }
}

@JsonSerializable()
class Clips {
  @JsonKey(name: "clip_group_id")
  final int? clipGroupId;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "clip_text")
  final String? clipText;
  @JsonKey(name: "audio_url")
  final String? audioUrl;
  @JsonKey(name: "insert_child_name")
  final String? insertChildName;
  @JsonKey(name: "pause_after_name")
  final int? pauseAfterName;
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "sort_order")
  final int? sortOrder;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "insert_siblings_name")
  final String? insertSiblingsName;
  @JsonKey(name: "insert_friends_name")
  final String? insertFriendsName;
  @JsonKey(name: "insert_best_playmate")
  final String? insertBestPlaymate;
  @JsonKey(name: "kids_favorite_images")
  final String? kidsFavoriteImages;

  Clips ({
    this.clipGroupId,
    this.imageUrl,
    this.clipText,
    this.audioUrl,
    this.insertChildName,
    this.pauseAfterName,
    this.storyId,
    this.sortOrder,
    this.createdAt,
    this.insertSiblingsName,
    this.insertFriendsName,
    this.insertBestPlaymate,
    this.kidsFavoriteImages,
  });

  factory Clips.fromJson(Map<String, dynamic> json) {
    return _$ClipsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ClipsToJson(this);
  }
}


