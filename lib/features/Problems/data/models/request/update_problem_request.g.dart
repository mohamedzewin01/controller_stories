// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_problem_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProblemRequest _$UpdateProblemRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProblemRequest(
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
);

Map<String, dynamic> _$UpdateProblemRequestToJson(
  UpdateProblemRequest instance,
) => <String, dynamic>{
  'problem_id': instance.problemId,
  'problem_title': instance.problemTitle,
  'problem_description': instance.problemDescription,
};
