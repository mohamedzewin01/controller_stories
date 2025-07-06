import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';

import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/update_story.dart';

import '../repositories/Stories_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Stories_useCase_repo.dart';

@Injectable(as: StoriesUseCaseRepo)
class StoriesUseCase implements StoriesUseCaseRepo {
  final StoriesRepository repository;

  StoriesUseCase(this.repository);

  @override
  Future<Result<FetchStoriesByCategoryEntity?>> fetchStoriesByCategory(
    int categoryId,
  ) {
    return repository.fetchStoriesByCategory(categoryId);
  }

  @override
  Future<Result<AddStoryEntity?>> addStory({
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
    return repository.addStory(
      title,
      storyDescription,
      problemId,
      gender,
      ageGroup,
      categoryId,
      isActive,
      imageCover!,
      bestFriendGender,
    );
  }

  @override
  Future<Result<DeleteStoryEntity?>> deleteStory(int storyId) {
    return repository.deleteStory(storyId);
  }

  @override
  Future<Result<UpdateStoryEntity?>> updateStory({
    required int storyId,
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
    return repository.updateStory(
      storyId,
      title: title,
      storyDescription: storyDescription,
      imageCover: imageCover,
      ageGroup: ageGroup,
      isActive: isActive,
      gender: gender,
      categoryId: categoryId,
      problemId: problemId,
      bestFriendGender: bestFriendGender,
    );
  }
}
