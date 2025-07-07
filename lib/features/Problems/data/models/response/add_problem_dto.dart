import 'package:controller_stories/features/Problems/domain/entities/add_problem_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_problem_dto.g.dart';

@JsonSerializable()
class AddProblemDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  AddProblemDto ({
    this.status,
    this.message,
  });

  factory AddProblemDto.fromJson(Map<String, dynamic> json) {
    return _$AddProblemDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddProblemDtoToJson(this);
  }
  AddProblemEntity toEntity() {
    return AddProblemEntity(
      status: status,
      message: message,
    );
  }
}


