// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllStoriesDto _$GetAllStoriesDtoFromJson(Map<String, dynamic> json) =>
    GetAllStoriesDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllStoriesDtoToJson(GetAllStoriesDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  problemId: (json['problem_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  gender: json['gender'] as String?,
  ageGroup: json['age_group'] as String?,
  isActive: (json['is_active'] as num?)?.toInt(),
  categoryId: (json['category_id'] as num?)?.toInt(),
  bestFriendGender: json['best_friend_gender'] as String?,
  viewsCount: (json['views_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'problem_id': instance.problemId,
  'created_at': instance.createdAt,
  'gender': instance.gender,
  'age_group': instance.ageGroup,
  'is_active': instance.isActive,
  'category_id': instance.categoryId,
  'best_friend_gender': instance.bestFriendGender,
  'views_count': instance.viewsCount,
};
