// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_stories_by_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchStoriesByCategoryDto _$FetchStoriesByCategoryDtoFromJson(
  Map<String, dynamic> json,
) => FetchStoriesByCategoryDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  count: (json['count'] as num?)?.toInt(),
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FetchStoriesByCategoryDtoToJson(
  FetchStoriesByCategoryDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'count': instance.count,
  'stories': instance.stories,
};

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  gender: json['gender'] as String?,
  bestFriendGender: json['best_friend_gender'] as String?,
  isActive: (json['is_active'] as num?)?.toInt(),
  ageGroup: json['age_group'] as String?,
  createdAt: json['created_at'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
  problemCategoryId: (json['problem_category_id'] as num?)?.toInt(),
  problemCreatedAt: json['problem_created_at'] as String?,
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'gender': instance.gender,
  'best_friend_gender': instance.bestFriendGender,
  'is_active': instance.isActive,
  'age_group': instance.ageGroup,
  'created_at': instance.createdAt,
  'category_id': instance.categoryId,
  'problem_id': instance.problemId,
  'problem_title': instance.problemTitle,
  'problem_description': instance.problemDescription,
  'problem_category_id': instance.problemCategoryId,
  'problem_created_at': instance.problemCreatedAt,
};
