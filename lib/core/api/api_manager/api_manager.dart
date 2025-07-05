import 'dart:io';

import 'package:controller_stories/features/Categories/data/models/request/delete_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/insert_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/response/delete_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/insert_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/update_category_dto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:controller_stories/core/api/api_constants.dart';

part 'api_manager.g.dart';

@injectable
@singleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  @FactoryMethod()
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.fetchCategories)
  Future<FetchCategoriesDto?> fetchCategories();

  @POST(ApiConstants.insertCategory)
  Future<InsertCategoryDto?> insertCategory(
    @Body() InsertCategoryRequest insertCategoryRequest,
  );

  @POST(ApiConstants.updateCategory)
  Future<UpdateCategoryDto?> updateCategory(
    @Body() UpdateCategoryRequest updateCategoryRequest,
  );

  @POST(ApiConstants.deleteCategory)
  Future<DeleteCategoryDto?> deleteCategory(
    @Body() DeleteCategoryRequest deleteCategoryRequest,
  );
}

//  @MultiPart()
