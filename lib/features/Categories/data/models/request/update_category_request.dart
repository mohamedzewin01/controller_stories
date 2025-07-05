import 'package:json_annotation/json_annotation.dart';

part 'update_category_request.g.dart';

@JsonSerializable()
class UpdateCategoryRequest {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "is_Active")
  final int? isActive;

  UpdateCategoryRequest ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.isActive,
  });

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateCategoryRequestToJson(this);
  }
}


