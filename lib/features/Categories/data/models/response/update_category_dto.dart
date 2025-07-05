import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_category_dto.g.dart';

@JsonSerializable()
class UpdateCategoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  UpdateCategoryDto ({
    this.status,
    this.message,
  });

  factory UpdateCategoryDto.fromJson(Map<String, dynamic> json) {
    return _$UpdateCategoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateCategoryDtoToJson(this);
  }
  UpdateCategoryEntity toEntity() {
    return UpdateCategoryEntity(
      status: status,
      message: message,
    );
  }
}


