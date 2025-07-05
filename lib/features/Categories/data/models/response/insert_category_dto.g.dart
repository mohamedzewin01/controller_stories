// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsertCategoryDto _$InsertCategoryDtoFromJson(Map<String, dynamic> json) =>
    InsertCategoryDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      categoryId: json['category_id'] as String?,
    );

Map<String, dynamic> _$InsertCategoryDtoToJson(InsertCategoryDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'category_id': instance.categoryId,
    };
