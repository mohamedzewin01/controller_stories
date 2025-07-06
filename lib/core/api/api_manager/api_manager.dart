import 'dart:io';

import 'package:controller_stories/features/Categories/data/models/request/delete_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/insert_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/response/delete_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/insert_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/update_category_dto.dart';
import 'package:controller_stories/features/Stories/data/models/request/delete_story_request.dart';
import 'package:controller_stories/features/Stories/data/models/request/fetch_stories_by_category_request.dart';
import 'package:controller_stories/features/Stories/data/models/response/add_story_dto.dart';
import 'package:controller_stories/features/Stories/data/models/response/delete_story_dto.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
import 'package:controller_stories/features/Stories/data/models/response/update_story_dto.dart';
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
  @POST(ApiConstants.fetchStoriesByCategory)
  Future<FetchStoriesByCategoryDto?> fetchStoriesByCategory(
    @Body() FetchStoriesByCategoryRequest fetchStoriesByCategoryRequest,
  );
  @POST(ApiConstants.deleteStory)
  Future<DeleteStoryDto?> deleteStory(
    @Body() DeleteStoryRequest deleteStoryRequest,
  );


  @MultiPart()
  @POST(ApiConstants.addStory)
  Future<AddStoryDto?> addStory(
      @Part(name: "story_title") String? title,
      @Part(name: "story_description") String? storyDescription,
      @Part(name: "problem_id") int? problemId,
      @Part(name: "gender") String? gender,
      @Part(name: "age_group") String? ageGroup,
      @Part(name: "category_id") int? categoryId,
      @Part(name: "is_active") int? isActive,
      @Part(name: "image_cover") File? imageCover,
      @Part(name: "best_friend_gender") String? bestFriendGender,
      );

  @MultiPart()
  @POST(ApiConstants.updateStory)
  Future<UpdateStoryDto?> updateStory(
      @Part(name: "story_id") int storyId,
      @Part(name: "story_title") String? title,
      @Part(name: "story_description") String? storyDescription,
      @Part(name: "problem_id") int? problemId,
      @Part(name: "gender") String? gender,
      @Part(name: "age_group") String? ageGroup,
      @Part(name: "category_id") int? categoryId,
      @Part(name: "is_active") int? isActive,
      @Part(name: "image_cover") File? imageCover,
      @Part(name: "best_friend_gender") String? bestFriendGender,
      );

}

//  @MultiPart()
