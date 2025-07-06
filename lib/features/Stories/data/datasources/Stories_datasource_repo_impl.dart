import 'dart:io';

import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/data/models/request/delete_story_request.dart';
import 'package:controller_stories/features/Stories/data/models/request/fetch_stories_by_category_request.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';

import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/update_story.dart';

import 'Stories_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: StoriesDatasourceRepo)
class StoriesDatasourceRepoImpl implements StoriesDatasourceRepo {
  final ApiService apiService;

  StoriesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<FetchStoriesByCategoryEntity>> fetchStoriesByCategory(
      int categoryId,) {
    return executeApi(() async {
      FetchStoriesByCategoryRequest fetchStoriesByCategoryRequest =
      FetchStoriesByCategoryRequest(categoryId: categoryId);
      final response = await apiService.fetchStoriesByCategory(
        fetchStoriesByCategoryRequest,
      );
      return response!.toEntity();
    });
  }

  @override
  Future<Result<AddStoryEntity?>> addStory(String? title,
      String? storyDescription,
      int? problemId,
      String? gender,
      String? ageGroup,
      int? categoryId,
      int? isActive,
      File imageCover,
      String? bestFriendGender,) {
    return executeApi(() async {
      final response = await apiService.addStory(
        title,
        storyDescription,
        problemId,
        gender,
        ageGroup,
        categoryId,
        isActive,
        imageCover,
        bestFriendGender,
      );
      return response!.toEntity();
    });
  }

  @override
  Future<Result<DeleteStoryEntity?>> deleteStory(int storyId) {
    return executeApi(() async {
      final response = await apiService.deleteStory(
        DeleteStoryRequest(storyId: storyId),
      );
      return response!.toEntity();
    });
  }

  @override
  Future<Result<UpdateStoryEntity?>> updateStory(int storyId, {
    String? title,
    String? storyDescription,
    int? problemId,
    String? gender,
    String? ageGroup,
    int? categoryId,
    int? isActive,
    File? imageCover,
    String? bestFriendGender,
  }) {
    return executeApi(() async {
      final response = await apiService.updateStory(
        storyId,
        title,
        storyDescription,
        problemId,
        gender,
        ageGroup,
        categoryId,
        isActive,
        imageCover,
        bestFriendGender,
      );
      return response!.toEntity();
    });
  }
}