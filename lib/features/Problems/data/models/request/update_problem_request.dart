import 'package:json_annotation/json_annotation.dart';

part 'update_problem_request.g.dart';

@JsonSerializable()
class UpdateProblemRequest {
  @JsonKey(name: "problem_id")
  final int? problemId;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;

  UpdateProblemRequest ({
    this.problemId,
    this.problemTitle,
    this.problemDescription,
  });

  factory UpdateProblemRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateProblemRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateProblemRequestToJson(this);
  }
}


