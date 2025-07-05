import 'package:json_annotation/json_annotation.dart';

part 'fetch_stories_by_category_request.g.dart';

@JsonSerializable()
class FetchStoriesByCategoryRequest {
  @JsonKey(name: "category_id")
  final int? categoryId;

  FetchStoriesByCategoryRequest ({
    this.categoryId,
  });

  factory FetchStoriesByCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$FetchStoriesByCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FetchStoriesByCategoryRequestToJson(this);
  }
}


