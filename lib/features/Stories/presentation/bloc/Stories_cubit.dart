import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Stories/domain/entities/add_story_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/delete_story_dto.dart';
import 'package:controller_stories/features/Stories/domain/entities/fetch_stories_entity.dart';
import 'package:controller_stories/features/Stories/domain/entities/update_story.dart';
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
    required String? bestFriendGender,
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
      bestFriendGender: bestFriendGender,
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

  // Update Story
  Future<void> updateStory({
    required int storyId,
    String? title,
    String? storyDescription,
    int? problemId,
    String? gender,
    String? ageGroup,
    int? categoryId,
    bool? isActive,
    File? imageCover,
    String? bestFriendGender,
  }) async {
    emit(StoriesLoadingAction());

    var result = await _storiesUseCaseRepo.updateStory(
      storyId: storyId,
      title: title,
      storyDescription: storyDescription,
      problemId: problemId,
      gender: gender,
      ageGroup: ageGroup,
      categoryId: categoryId,
      isActive: isActive != null ? (isActive ? 1 : 0) : null,
      imageCover: imageCover,
      bestFriendGender: bestFriendGender,
    );

    switch (result) {
      case Success<UpdateStoryEntity?>():
        if (!isClosed) {
          emit(StoriesUpdateSuccess(result.data!));
          // Refresh the stories list
          if (_currentCategoryId != null) {
            await fetchStoriesByCategory(_currentCategoryId!);
          }
        }
        break;
      case Fail<UpdateStoryEntity?>():
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

  // Search Stories
  // Future<void> searchStories(String query) async {
  //   if (query.trim().isEmpty) {
  //     // If search is empty, show all stories
  //     if (_currentCategoryId != null) {
  //       await fetchStoriesByCategory(_currentCategoryId!);
  //     }
  //     return;
  //   }
  //
  //   try {
  //     final filteredStories = _currentStories.where((story) {
  //       final titleMatch = story.storyTitle?.toLowerCase().contains(query.toLowerCase()) ?? false;
  //       final descriptionMatch = story.storyDescription?.toLowerCase().contains(query.toLowerCase()) ?? false;
  //       final problemMatch = story.problemTitle?.toLowerCase().contains(query.toLowerCase()) ?? false;
  //
  //       return titleMatch || descriptionMatch || problemMatch;
  //     }).toList();
  //
  //     final searchResult = FetchStoriesByCategoryEntity(
  //       status: 'success',
  //       message: 'Search completed',
  //       count: filteredStories.length,
  //       stories: filteredStories,
  //     );
  //
  //     emit(StoriesSearchResult(searchResult, query));
  //   } catch (e) {
  //     emit(StoriesFailure(Exception('Search failed: $e')));
  //   }
  // }

  // Filter Stories by Gender
  // Future<void> filterStoriesByGender(String gender) async {
  //   try {
  //     final filteredStories = _currentStories.where((story) {
  //       if (gender.toLowerCase() == 'all') return true;
  //       return story.gender?.toLowerCase() == gender.toLowerCase();
  //     }).toList();
  //
  //     final filterResult = FetchStoriesByCategoryEntity(
  //       status: 'success',
  //       message: 'Filter applied',
  //       count: filteredStories.length,
  //       stories: filteredStories,
  //     );
  //
  //     emit(StoriesFilterByGenderResult(filterResult, gender));
  //   } catch (e) {
  //     emit(StoriesFailure(Exception('Filter failed: $e')));
  //   }
  // }

  // Filter Stories by Age Group
  // Future<void> filterStoriesByAge(String ageGroup) async {
  //   try {
  //     final filteredStories = _currentStories.where((story) {
  //       if (ageGroup.toLowerCase() == 'all') return true;
  //       return story.ageGroup?.toLowerCase() == ageGroup.toLowerCase();
  //     }).toList();
  //
  //     final filterResult = FetchStoriesByCategoryEntity(
  //       status: 'success',
  //       message: 'Age filter applied',
  //       count: filteredStories.length,
  //       stories: filteredStories,
  //     );
  //
  //     emit(StoriesFilterByAgeResult(filterResult, ageGroup));
  //   } catch (e) {
  //     emit(StoriesFailure(Exception('Age filter failed: $e')));
  //   }
  // }

  // // Filter Stories by Best Friend Gender
  // Future<void> filterStoriesByBestFriend(String bestFriendGender) async {
  //   try {
  //     final filteredStories = _currentStories.where((story) {
  //       if (bestFriendGender.toLowerCase() == 'all') return true;
  //       return story.bestFriendGender?.toLowerCase() == bestFriendGender.toLowerCase();
  //     }).toList();
  //
  //     final filterResult = FetchStoriesByCategoryEntity(
  //       status: 'success',
  //       message: 'Best friend filter applied',
  //       count: filteredStories.length,
  //       stories: filteredStories,
  //     );
  //
  //     emit(StoriesFilterByBestFriendResult(filterResult, bestFriendGender));
  //   } catch (e) {
  //     emit(StoriesFailure(Exception('Best friend filter failed: $e')));
  //   }
  // }

  // Clear all filters and show original stories
  Future<void> clearFilters() async {
    if (_currentCategoryId != null) {
      await fetchStoriesByCategory(_currentCategoryId!);
    }
  }

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

  // Get Stories by Age Group Count
  int getStoriesByAgeGroupCount(String ageGroup) {
    return _currentStories.where((story) =>
    story.ageGroup?.toLowerCase() == ageGroup.toLowerCase()).length;
  }

  // Get Stories by Best Friend Gender Count
  int getStoriesByBestFriendCount(String bestFriendGender) {
    return _currentStories.where((story) =>
    story.bestFriendGender?.toLowerCase() == bestFriendGender.toLowerCase()).length;
  }

  // Get Current Stories (for external access)
  List<dynamic> getCurrentStories() => List.from(_currentStories);

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

  // Get unique best friend genders
  List<String> getUniqueBestFriendGenders() {
    final bestFriendGenders = _currentStories
        .map((story) => story.bestFriendGender)
        .where((bestFriendGender) => bestFriendGender != null)
        .cast<String>()
        .toSet()
        .toList();
    return bestFriendGenders;
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final totalStories = _currentStories.length;
    final boyStories = getStoriesByGenderCount('Boy');
    final girlStories = getStoriesByGenderCount('Girl');
    final bothStories = getStoriesByGenderCount('Both');
    final maleFreindStories = getStoriesByBestFriendCount('Male');
    final femaleFreindStories = getStoriesByBestFriendCount('Female');

    return {
      'total': totalStories,
      'boy': boyStories,
      'girl': girlStories,
      'both': bothStories,
      'maleFriend': maleFreindStories,
      'femaleFriend': femaleFreindStories,
      'ageGroups': getUniqueAgeGroups(),
      'genders': getUniqueGenders(),
      'bestFriendGenders': getUniqueBestFriendGenders(),
    };
  }
}