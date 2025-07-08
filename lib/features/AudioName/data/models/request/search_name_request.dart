import 'package:json_annotation/json_annotation.dart';

part 'search_name_request.g.dart';

@JsonSerializable()
class SearchNameRequest {
  @JsonKey(name: "name")
  final String? name;

  SearchNameRequest ({
    this.name,
  });

  factory SearchNameRequest.fromJson(Map<String, dynamic> json) {
    return _$SearchNameRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SearchNameRequestToJson(this);
  }
}


