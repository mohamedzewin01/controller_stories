// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_clips_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchClipsDto _$FetchClipsDtoFromJson(Map<String, dynamic> json) =>
    FetchClipsDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      count: (json['count'] as num?)?.toInt(),
      clips: (json['clips'] as List<dynamic>?)
          ?.map((e) => Clips.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FetchClipsDtoToJson(FetchClipsDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'count': instance.count,
      'clips': instance.clips,
    };

Clips _$ClipsFromJson(Map<String, dynamic> json) => Clips(
  clipGroupId: (json['clip_group_id'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  clipText: json['clip_text'] as String?,
  audioUrl: json['audio_url'] as String?,
  insertChildName: json['insert_child_name'] as String?,
  pauseAfterName: (json['pause_after_name'] as num?)?.toInt(),
  storyId: (json['story_id'] as num?)?.toInt(),
  sortOrder: (json['sort_order'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  insertSiblingsName: json['insert_siblings_name'] as String?,
  insertFriendsName: json['insert_friends_name'] as String?,
  insertBestPlaymate: json['insert_best_playmate'] as String?,
  kidsFavoriteImages: json['kids_favorite_images'] as String?,
);

Map<String, dynamic> _$ClipsToJson(Clips instance) => <String, dynamic>{
  'clip_group_id': instance.clipGroupId,
  'image_url': instance.imageUrl,
  'clip_text': instance.clipText,
  'audio_url': instance.audioUrl,
  'insert_child_name': instance.insertChildName,
  'pause_after_name': instance.pauseAfterName,
  'story_id': instance.storyId,
  'sort_order': instance.sortOrder,
  'created_at': instance.createdAt,
  'insert_siblings_name': instance.insertSiblingsName,
  'insert_friends_name': instance.insertFriendsName,
  'insert_best_playmate': instance.insertBestPlaymate,
  'kids_favorite_images': instance.kidsFavoriteImages,
};
