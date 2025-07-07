import 'package:controller_stories/features/Problems/domain/entities/update_problem_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_problem_dto.g.dart';

@JsonSerializable()
class UpdateProblemDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  UpdateProblemDto({this.status, this.message});

  factory UpdateProblemDto.fromJson(Map<String, dynamic> json) {
    return _$UpdateProblemDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateProblemDtoToJson(this);
  }

  UpdateProblemEntity toEntity() {
    return UpdateProblemEntity(status: status, message: message);
  }
}
