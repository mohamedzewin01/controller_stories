// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file_empty_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioFileEmptyDto _$AudioFileEmptyDtoFromJson(Map<String, dynamic> json) =>
    AudioFileEmptyDto(
      status: json['status'] as String?,
      total: (json['total'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataFileEmpty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AudioFileEmptyDtoToJson(AudioFileEmptyDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
      'data': instance.data,
    };

DataFileEmpty _$DataFileEmptyFromJson(Map<String, dynamic> json) =>
    DataFileEmpty(
      nameAudioId: (json['name_audio_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      audioFile: json['audio_file'],
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$DataFileEmptyToJson(DataFileEmpty instance) =>
    <String, dynamic>{
      'name_audio_id': instance.nameAudioId,
      'name': instance.name,
      'audio_file': instance.audioFile,
      'created_at': instance.createdAt,
    };
