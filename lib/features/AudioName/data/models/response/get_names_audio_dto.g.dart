// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_names_audio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNamesAudioDto _$GetNamesAudioDtoFromJson(Map<String, dynamic> json) =>
    GetNamesAudioDto(
      status: json['status'] as String?,
      currentPage: (json['current_page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNamesAudioDtoToJson(GetNamesAudioDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'total_pages': instance.totalPages,
      'data': instance.data,
    };

DataAudio _$DataAudioFromJson(Map<String, dynamic> json) => DataAudio(
  nameAudioId: (json['name_audio_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  audioFile: json['audio_file'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$DataAudioToJson(DataAudio instance) => <String, dynamic>{
  'name_audio_id': instance.nameAudioId,
  'name': instance.name,
  'audio_file': instance.audioFile,
  'created_at': instance.createdAt,
};
