import 'package:json_annotation/json_annotation.dart';

part 'insert_category_request.g.dart';

@JsonSerializable()
class InsertCategoryRequest {
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "is_Active")
  final int? isActive;

  InsertCategoryRequest ({
    this.categoryName,
    this.categoryDescription,
    this.isActive,
  });

  factory InsertCategoryRequest.fromJson(Map<String, dynamic> json) {
    return _$InsertCategoryRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$InsertCategoryRequestToJson(this);
  }
}


