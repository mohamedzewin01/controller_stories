import 'package:json_annotation/json_annotation.dart';

part 'delete_category_request.g.dart';

@JsonSerializable()
class DeleteCategoryRequest {
  @JsonKey(name: "category_id")
  final int? categoryId;

  DeleteCategoryRequest ({
    this.categoryId,
  });

  factory DeleteCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteCategoryRequestToJson(this);
  }
}


