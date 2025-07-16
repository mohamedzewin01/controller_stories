// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_replies_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddRepliesDto _$AddRepliesDtoFromJson(Map<String, dynamic> json) =>
    AddRepliesDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      replyId: json['reply_id'] as String?,
    );

Map<String, dynamic> _$AddRepliesDtoToJson(AddRepliesDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'reply_id': instance.replyId,
    };
