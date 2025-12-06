import 'package:json_annotation/json_annotation.dart';

part 'get_user_codes_request.g.dart';

@JsonSerializable()
class GetUserCodesRequest {
  @JsonKey(name: "filter") // الخيارات: "all", "unused", "used", "expired"
  final String? filter;
  @JsonKey(name: "page")
  final int? page;

  GetUserCodesRequest ({
    this.filter,
    this.page,
  });

  factory GetUserCodesRequest.fromJson(Map<String, dynamic> json) {
    return _$GetUserCodesRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserCodesRequestToJson(this);
  }
}


