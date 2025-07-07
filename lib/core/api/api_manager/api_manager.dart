import 'dart:io';

import 'package:controller_stories/features/Categories/data/models/request/delete_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/insert_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/response/delete_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/insert_category_dto.dart';
import 'package:controller_stories/features/Categories/data/models/response/update_category_dto.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/delete_clip_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/fetch_clips_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/data/models/response/delete_clip_dto.dart';
import 'package:controller_stories/features/Clips/data/models/response/edit_clip_dto.dart';
import 'package:controller_stories/features/Clips/data/models/response/fetch_clips_dto.dart';
import 'package:controller_stories/features/Problems/data/models/request/add_problem_request.dart';
import 'package:controller_stories/features/Problems/data/models/request/delete_problem_request.dart';
import 'package:controller_stories/features/Problems/data/models/request/update_problem_request.dart';
import 'package:controller_stories/features/Problems/data/models/response/add_problem_dto.dart';
import 'package:controller_stories/features/Problems/data/models/response/delete_problem_dto.dart';
import 'package:controller_stories/features/Problems/data/models/response/get_problems_dto.dart';
import 'package:controller_stories/features/Problems/data/models/response/update_problem_dto.dart';
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

  @POST(ApiConstants.fetchClips)
  Future<FetchClipsDto?> fetchClips(
    @Body() FetchClipsRequest fetchClipsRequest,
  );

  @POST(ApiConstants.deleteClip)
  Future<DeleteClipDto?> deleteClip(
    @Body() DeleteClipRequest deleteClipRequest,
  );

  @MultiPart()
  @POST(ApiConstants.addClip)
  Future<AddClipsDto?> addClip(
    @Part(name: "story_id") int storyId,
    @Part(name: "clip_text") String? clipText,
    @Part(name: "sort_order") String? sortOrder,
    @Part(name: "pause_after_name") int? afterName,
    @Part(name: "insert_child_name") bool? childName,
    @Part(name: "insert_siblings_name") bool? siblingsName,
    @Part(name: "insert_friends_name") bool? friendsName,
    @Part(name: "insert_best_playmate") bool? bestFriendGender,
    @Part(name: "kids_favorite_images") bool? imageFavorite,
    @Part(name: "image") File? image,
    @Part(name: "audio") File? audio,
  );

  @MultiPart()
  @POST(ApiConstants.editClip)
  Future<EditClipDto?> editClip(
    @Part(name: "clip_group_id") int clipGroupId,
    @Part(name: "clip_text") String? clipText,
    @Part(name: "pause_after_name") int? afterName,
    @Part(name: "sort_order") int? sortOrder,
    @Part(name: "insert_child_name") bool? childName,
    @Part(name: "insert_siblings_name") bool? siblingsName,
    @Part(name: "insert_friends_name") bool? friendsName,
    @Part(name: "insert_best_playmate") bool? bestFriendGender,
    @Part(name: "kids_favorite_images") bool? imageFavorite,
    @Part(name: "image") File? image,
    @Part(name: "audio") File? audio,
  );

  @POST(ApiConstants.getProblems)
  Future<GetProblemsDto?> getProblems();

  @POST(ApiConstants.addProblem)
  Future<AddProblemDto?> addProblem(
    @Body() AddProblemRequest addProblemRequest,
  );

  @POST(ApiConstants.updateProblem)
  Future<UpdateProblemDto?> updateProblem(
    @Body() UpdateProblemRequest updateProblemRequest,
  );

  @POST(ApiConstants.deleteProblem)
  Future<DeleteProblemDto?> deleteProblem(
    @Body() DeleteProblemRequest updateProblemRequest,
  );
}
