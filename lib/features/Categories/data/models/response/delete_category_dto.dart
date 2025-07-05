import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_category_dto.g.dart';

@JsonSerializable()
class DeleteCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteCategoryDto ({
    this.status,
    this.message,
  });

  factory DeleteCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteCategoryDtoToJson(this);
  }
  DeleteCategoryEntity toEntity() {
    return DeleteCategoryEntity(
      status: status,
      message: message,
    );
  }
}


