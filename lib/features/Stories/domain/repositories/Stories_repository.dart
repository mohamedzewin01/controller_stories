import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';
import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';

abstract class StoriesRepository {
  Future<Result<FetchStoriesByCategoryEntity?>>fetchStoriesByCategory(int categoryId);
  Future<Result<AddStoryEntity?>> addStory(
      String? title,
      String? storyDescription,
      int? problemId,
      String? gender,
      String? ageGroup,
      int? categoryId,
      int? isActive,
      File imageCover,
      );
  Future<Result<DeleteStoryEntity?>> deleteStory(int storyId);
}
