// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsertCategoryRequest _$InsertCategoryRequestFromJson(
  Map<String, dynamic> json,
) => InsertCategoryRequest(
  categoryName: json['category_name'] as String?,
  categoryDescription: json['category_description'] as String?,
  isActive: (json['is_Active'] as num?)?.toInt(),
);

Map<String, dynamic> _$InsertCategoryRequestToJson(
  InsertCategoryRequest instance,
) => <String, dynamic>{
  'category_name': instance.categoryName,
  'category_description': instance.categoryDescription,
  'is_Active': instance.isActive,
};
