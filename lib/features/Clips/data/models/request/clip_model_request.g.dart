// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_model_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipModelRequest _$ClipModelRequestFromJson(
  Map<String, dynamic> json,
) => ClipModelRequest(
  storyId: (json['story_id'] as num).toInt(),
  clipText: json['clip_text'] as String,
  imageUrl: json['image_url'] as String,
  audioUrl: json['audio_url'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
  insertChildName: json['insert_child_name'] == null
      ? false
      : ClipModelRequest._boolFromString(json['insert_child_name'] as String),
  pauseAfterName: (json['pause_after_name'] as num?)?.toInt() ?? 1000,
  insertSiblingsName: json['insert_siblings_name'] == null
      ? false
      : ClipModelRequest._boolFromString(
          json['insert_siblings_name'] as String,
        ),
  insertFriendsName: json['insert_friends_name'] == null
      ? false
      : ClipModelRequest._boolFromString(json['insert_friends_name'] as String),
  insertBestPlaymate: json['insert_best_playmate'] == null
      ? false
      : ClipModelRequest._boolFromString(
          json['insert_best_playmate'] as String,
        ),
);

Map<String, dynamic> _$ClipModelRequestToJson(
  ClipModelRequest instance,
) => <String, dynamic>{
  'story_id': instance.storyId,
  'clip_text': instance.clipText,
  'image_url': instance.imageUrl,
  'audio_url': instance.audioUrl,
  'sort_order': instance.sortOrder,
  'insert_child_name': ClipModelRequest._boolToString(instance.insertChildName),
  'pause_after_name': instance.pauseAfterName,
  'insert_siblings_name': ClipModelRequest._boolToString(
    instance.insertSiblingsName,
  ),
  'insert_friends_name': ClipModelRequest._boolToString(
    instance.insertFriendsName,
  ),
  'insert_best_playmate': ClipModelRequest._boolToString(
    instance.insertBestPlaymate,
  ),
};
