import 'package:controller_stories/features/Problems/domain/entities/delete_problem_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_problem_dto.g.dart';

@JsonSerializable()
class DeleteProblemDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteProblemDto ({
    this.status,
    this.message,
  });

  factory DeleteProblemDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteProblemDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteProblemDtoToJson(this);
  }
  DeleteProblemEntity toEntity() {
    return DeleteProblemEntity(
      status: status,
      message: message,
    );
  }
}


