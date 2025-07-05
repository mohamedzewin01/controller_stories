import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';
import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Stories_useCase_repo.dart';

part 'Stories_state.dart';

@injectable
class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit(this._storiesUseCaseRepo) : super(StoriesInitial());
  final StoriesUseCaseRepo _storiesUseCaseRepo;

  // Store current stories for local operations
  List<dynamic> _currentStories = [];
  int? _currentCategoryId;

  // Fetch Stories by Category
  Future<void> fetchStoriesByCategory(int categoryId) async {
    emit(StoriesLoading());
    _currentCategoryId = categoryId;

    var result = await _storiesUseCaseRepo.fetchStoriesByCategory(categoryId);
    switch (result) {
      case Success<FetchStoriesByCategoryEntity?>():
        if (!isClosed && result.data != null) {
          _currentStories = result.data!.stories ?? [];
          emit(StoriesSuccess(result.data!));
        }
        break;
      case Fail<FetchStoriesByCategoryEntity?>():
        if (!isClosed) {
          emit(StoriesFailure(result.exception));
        }
        break;
    }
  }

  // Add Story
  Future<void> addStory({
    required String title,
    required String storyDescription,
    required int problemId,
    required String gender,
    required String ageGroup,
    required int categoryId,
    required bool isActive,
    required File imageCover,
  }) async {
    emit(StoriesLoadingAction());

    var result = await _storiesUseCaseRepo.addStory(
      title: title,
      storyDescription: storyDescription,
      problemId: problemId,
      gender: gender,
      ageGroup: ageGroup,
      categoryId: categoryId,
      isActive: isActive ? 1 : 0,
      imageCover: imageCover,
    );

    switch (result) {
      case Success<AddStoryEntity?>():
        if (!isClosed) {
          emit(StoriesAddSuccess(result.data!));
          // Refresh the stories list if we're viewing the same category
          if (_currentCategoryId == categoryId) {
            await fetchStoriesByCategory(categoryId);
          }
        }
        break;
      case Fail<AddStoryEntity?>():
        if (!isClosed) {
          emit(StoriesFailure(result.exception));
        }
        break;
    }
  }

  // Delete Story
  Future<void> deleteStory(int storyId) async {
    emit(StoriesLoadingAction());

    var result = await _storiesUseCaseRepo.deleteStory(storyId);

    switch (result) {
      case Success<DeleteStoryEntity?>():
        if (!isClosed) {
          emit(StoriesDeleteSuccess(result.data!));
          // Refresh the stories list
          if (_currentCategoryId != null) {
            await fetchStoriesByCategory(_currentCategoryId!);
          }
        }
        break;
      case Fail<DeleteStoryEntity?>():
        if (!isClosed) {
          emit(StoriesFailure(result.exception));
        }
        break;
    }
  }



  // Filter Stories by Gender




  // Get Story by ID
  dynamic getStoryById(int storyId) {
    try {
      return _currentStories.firstWhere(
            (story) => story.storyId == storyId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get Stories Count
  int getStoriesCount() => _currentStories.length;

  // Get Stories by Gender Count
  int getStoriesByGenderCount(String gender) {
    return _currentStories.where((story) =>
    story.gender?.toLowerCase() == gender.toLowerCase()).length;
  }



  // Refresh Stories
  Future<void> refreshStories() async {
    if (_currentCategoryId != null) {
      await fetchStoriesByCategory(_currentCategoryId!);
    }
  }

  // Get unique age groups
  List<String> getUniqueAgeGroups() {
    final ageGroups = _currentStories
        .map((story) => story.ageGroup)
        .where((ageGroup) => ageGroup != null)
        .cast<String>()
        .toSet()
        .toList();
    return ageGroups;
  }

  // Get unique genders
  List<String> getUniqueGenders() {
    final genders = _currentStories
        .map((story) => story.gender)
        .where((gender) => gender != null)
        .cast<String>()
        .toSet()
        .toList();
    return genders;
  }
}