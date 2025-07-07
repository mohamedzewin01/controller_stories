// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_problems_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProblemsDto _$GetProblemsDtoFromJson(Map<String, dynamic> json) =>
    GetProblemsDto(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataProblems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetProblemsDtoToJson(GetProblemsDto instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

DataProblems _$DataProblemsFromJson(Map<String, dynamic> json) => DataProblems(
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
  problemCategoryId: (json['problem_category_id'] as num?)?.toInt(),
  creatAt: json['creat_at'] as String?,
);

Map<String, dynamic> _$DataProblemsToJson(DataProblems instance) =>
    <String, dynamic>{
      'problem_id': instance.problemId,
      'problem_title': instance.problemTitle,
      'problem_description': instance.problemDescription,
      'problem_category_id': instance.problemCategoryId,
      'creat_at': instance.creatAt,
    };
