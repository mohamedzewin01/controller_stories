import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fetch_stories_by_category_dto.g.dart';

@JsonSerializable()
class FetchStoriesByCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  FetchStoriesByCategoryDto ({
    this.status,
    this.message,
    this.count,
    this.stories,
  });

  factory FetchStoriesByCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$FetchStoriesByCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FetchStoriesByCategoryDtoToJson(this);
  }
  FetchStoriesByCategoryEntity toEntity() {
    return FetchStoriesByCategoryEntity(
      status: status,
      message: message,
      count: count,
      stories: stories
    );
  }
}

@JsonSerializable()
class Stories {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "image_cover")
  final String? imageCover;
  @JsonKey(name: "story_description")
  final String? storyDescription;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age_group")
  final String? ageGroup;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_category_id")
  final int? problemCategoryId;
  @JsonKey(name: "problem_created_at")
  final String? problemCreatedAt;

  Stories ({
    this.storyId,
    this.storyTitle,
    this.imageCover,
    this.storyDescription,
    this.gender,
    this.ageGroup,
    this.createdAt,
    this.categoryId,
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCategoryId,
    this.problemCreatedAt,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}


