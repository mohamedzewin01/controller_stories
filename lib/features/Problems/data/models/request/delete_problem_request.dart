import 'package:json_annotation/json_annotation.dart';

part 'delete_problem_request.g.dart';

@JsonSerializable()
class DeleteProblemRequest {
  @JsonKey(name: "problem_id")
  final int? problemId;

  DeleteProblemRequest ({
    this.problemId,
  });

  factory DeleteProblemRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteProblemRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteProblemRequestToJson(this);
  }
}


