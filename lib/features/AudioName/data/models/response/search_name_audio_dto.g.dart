// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_name_audio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchNameAudioDto _$SearchNameAudioDtoFromJson(Map<String, dynamic> json) =>
    SearchNameAudioDto(
      status: json['status'] as String?,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataSearch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchNameAudioDtoToJson(SearchNameAudioDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
      'data': instance.data,
    };

DataSearch _$DataSearchFromJson(Map<String, dynamic> json) => DataSearch(
  nameAudioId: (json['name_audio_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  audioFile: json['audio_file'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$DataSearchToJson(DataSearch instance) =>
    <String, dynamic>{
      'name_audio_id': instance.nameAudioId,
      'name': instance.name,
      'audio_file': instance.audioFile,
      'created_at': instance.createdAt,
    };
