// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_active_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateActiveCodeRequest _$CreateActiveCodeRequestFromJson(
  Map<String, dynamic> json,
) => CreateActiveCodeRequest(
  allowedChildren: (json['allowed_children'] as num?)?.toInt(),
  durationMonths: (json['duration_months'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateActiveCodeRequestToJson(
  CreateActiveCodeRequest instance,
) => <String, dynamic>{
  'allowed_children': instance.allowedChildren,
  'duration_months': instance.durationMonths,
};
