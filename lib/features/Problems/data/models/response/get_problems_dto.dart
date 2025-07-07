import 'package:controller_stories/features/Problems/domain/entities/get_problems_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_problems_dto.g.dart';

@JsonSerializable()
class GetProblemsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "data")
  final List<DataProblems>? data;

  GetProblemsDto ({
    this.status,
    this.data,
  });

  factory GetProblemsDto.fromJson(Map<String, dynamic> json) {
    return _$GetProblemsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetProblemsDtoToJson(this);
  }
  GetProblemsEntity toEntity() {
    return GetProblemsEntity(
      status: status,
      data: data,
    );
  }
}

@JsonSerializable()
class DataProblems {
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;
  @JsonKey(name: "problem_category_id")
  final int? problemCategoryId;
  @JsonKey(name: "creat_at")
  final String? creatAt;

  DataProblems ({
    this.problemId,
    this.problemTitle,
    this.problemDescription,
    this.problemCategoryId,
    this.creatAt,
  });

  factory DataProblems.fromJson(Map<String, dynamic> json) {
    return _$DataProblemsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataProblemsToJson(this);
  }
}


