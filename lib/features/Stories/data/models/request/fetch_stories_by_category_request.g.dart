// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_stories_by_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchStoriesByCategoryRequest _$FetchStoriesByCategoryRequestFromJson(
  Map<String, dynamic> json,
) => FetchStoriesByCategoryRequest(
  categoryId: (json['category_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$FetchStoriesByCategoryRequestToJson(
  FetchStoriesByCategoryRequest instance,
) => <String, dynamic>{'category_id': instance.categoryId};
