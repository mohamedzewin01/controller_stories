import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_stories_dto.g.dart';

@JsonSerializable()
class GetAllStoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<Data>? data;

  GetAllStoriesDto ({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllStoriesDto.fromJson(Map<String, dynamic> json) {
    return _$GetAllStoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetAllStoriesDtoToJson(this);
  }
  GetAllStoriesEntity toEntity() {
    return GetAllStoriesEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class Data {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "story_description")
  final String? storyDescription;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "is_active")
  final int? isActive;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "best_friend_gender")
  final String? bestFriendGender;
  @JsonKey(name: "views_count")
  final int? viewsCount;

  Data ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.problemId,
    this.createdAt,
    this.gender,
    this.ageGroup,
    this.isActive,
    this.categoryId,
    this.bestFriendGender,
    this.viewsCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}


