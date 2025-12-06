import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_active_code_dto.g.dart';

@JsonSerializable()
class CreateActiveCodeDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "allowed_children")
  final int? allowedChildren;
  @JsonKey(name: "duration_months")
  final int? durationMonths;

  CreateActiveCodeDto ({
    this.status,
    this.message,
    this.code,
    this.allowedChildren,
    this.durationMonths,
  });

  factory CreateActiveCodeDto.fromJson(Map<String, dynamic> json) {
    return _$CreateActiveCodeDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CreateActiveCodeDtoToJson(this);
  }
  CreateActiveCodeEntity toEntity() {
    return CreateActiveCodeEntity(
      status: status,
      message: message,
      code: code,
      allowedChildren: allowedChildren,
      durationMonths: durationMonths,
    );
  }
}


