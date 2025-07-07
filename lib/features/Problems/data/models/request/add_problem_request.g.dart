// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_problem_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProblemRequest _$AddProblemRequestFromJson(Map<String, dynamic> json) =>
    AddProblemRequest(
      problemTitle: json['problem_title'] as String?,
      problemDescription: json['problem_description'] as String?,
    );

Map<String, dynamic> _$AddProblemRequestToJson(AddProblemRequest instance) =>
    <String, dynamic>{
      'problem_title': instance.problemTitle,
      'problem_description': instance.problemDescription,
    };
