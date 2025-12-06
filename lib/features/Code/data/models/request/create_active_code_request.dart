import 'package:json_annotation/json_annotation.dart';

part 'create_active_code_request.g.dart';

@JsonSerializable()
class CreateActiveCodeRequest {
  @JsonKey(name: "allowed_children")
  final int? allowedChildren;
  @JsonKey(name: "duration_months")
  final int? durationMonths;

  CreateActiveCodeRequest ({
    this.allowedChildren,
    this.durationMonths,
  });

  factory CreateActiveCodeRequest.fromJson(Map<String, dynamic> json) {
    return _$CreateActiveCodeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CreateActiveCodeRequestToJson(this);
  }
}


