import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fetch_categories_dto.g.dart';

@JsonSerializable()
class FetchCategoriesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "count")
  final int? count;
  @JsonKey(name: "categories")
  final List<Categories>? categories;

  FetchCategoriesDto ({
    this.status,
    this.message,
    this.count,
    this.categories,
  });

  factory FetchCategoriesDto.fromJson(Map<String, dynamic> json) {
    return _$FetchCategoriesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FetchCategoriesDtoToJson(this);
  }
  FetchCategoriesEntity toEntity() {
    return FetchCategoriesEntity(
      status: status,
      message: message,
      count: count,
      categories: categories
    );
  }
}

@JsonSerializable()
class Categories {
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "category_name")
  final String? categoryName;
  @JsonKey(name: "category_description")
  final String? categoryDescription;
  @JsonKey(name: "is_Active")
  final String? isActive;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Categories ({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.isActive,
    this.createdAt,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return _$CategoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesToJson(this);
  }
}


