// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_active_code_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateActiveCodeDto _$CreateActiveCodeDtoFromJson(Map<String, dynamic> json) =>
    CreateActiveCodeDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      code: json['code'] as String?,
      allowedChildren: (json['allowed_children'] as num?)?.toInt(),
      durationMonths: (json['duration_months'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateActiveCodeDtoToJson(
  CreateActiveCodeDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'code': instance.code,
  'allowed_children': instance.allowedChildren,
  'duration_months': instance.durationMonths,
};
