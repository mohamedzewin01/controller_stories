// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_replies_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddRepliesRequest _$AddRepliesRequestFromJson(Map<String, dynamic> json) =>
    AddRepliesRequest(
      requestId: (json['request_id'] as num?)?.toInt(),
      replyText: json['reply_text'] as String?,
      attachedStoryId: (json['attached_story_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddRepliesRequestToJson(AddRepliesRequest instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'reply_text': instance.replyText,
      'attached_story_id': instance.attachedStoryId,
    };
