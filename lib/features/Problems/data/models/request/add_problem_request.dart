import 'package:json_annotation/json_annotation.dart';

part 'add_problem_request.g.dart';

@JsonSerializable()
class AddProblemRequest {
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_description")
  final String? problemDescription;

  AddProblemRequest ({
    this.problemTitle,
    this.problemDescription,
  });

  factory AddProblemRequest.fromJson(Map<String, dynamic> json) {
    return _$AddProblemRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddProblemRequestToJson(this);
  }
}


