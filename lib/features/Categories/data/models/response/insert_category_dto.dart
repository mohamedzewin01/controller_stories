import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insert_category_dto.g.dart';

@JsonSerializable()



class InsertCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "category_id")
  final String? categoryId;

  InsertCategoryDto ({
    this.status,
    this.message,
    this.categoryId,
  });

  factory InsertCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$InsertCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$InsertCategoryDtoToJson(this);
  }
  InsertCategoryEntity toEntity() {
    return InsertCategoryEntity(
      status: status,
      message: message,
      categoryId: categoryId,
    );
  }
}