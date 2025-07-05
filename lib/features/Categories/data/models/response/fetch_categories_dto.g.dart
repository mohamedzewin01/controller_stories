// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_categories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchCategoriesDto _$FetchCategoriesDtoFromJson(Map<String, dynamic> json) =>
    FetchCategoriesDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      count: (json['count'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FetchCategoriesDtoToJson(FetchCategoriesDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'count': instance.count,
      'categories': instance.categories,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
  categoryId: (json['category_id'] as num?)?.toInt(),
  categoryName: json['category_name'] as String?,
  categoryDescription: json['category_description'] as String?,
  isActive: json['is_Active'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_description': instance.categoryDescription,
      'is_Active': instance.isActive,
      'created_at': instance.createdAt,
    };
