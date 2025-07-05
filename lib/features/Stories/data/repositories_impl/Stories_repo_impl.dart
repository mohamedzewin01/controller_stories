import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/data/datasources/Stories_datasource_repo.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';
import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/Stories_repository.dart';

@Injectable(as: StoriesRepository)
class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesDatasourceRepo storiesDatasourceRepo;

  StoriesRepositoryImpl(this.storiesDatasourceRepo);

  @override
  Future<Result<FetchStoriesByCategoryEntity?>> fetchStoriesByCategory(
    int categoryId,
  ) {
    return storiesDatasourceRepo.fetchStoriesByCategory(categoryId);
  }

  @override
  Future<Result<AddStoryEntity?>> addStory(
    String? title,
    String? storyDescription,
    int? problemId,
    String? gender,
    String? ageGroup,
    int? categoryId,
    int? isActive,
    File imageCover,
  ) {
    return storiesDatasourceRepo.addStory(
      title,
      storyDescription,
      problemId,
      gender,
      ageGroup,
      categoryId,
      isActive,
      imageCover,
    );
  }

  @override
  Future<Result<DeleteStoryEntity?>> deleteStory(int storyId) {
   return storiesDatasourceRepo.deleteStory(storyId);
  }
}
