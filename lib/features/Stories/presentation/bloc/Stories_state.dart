part of 'Stories_cubit.dart';

@immutable
sealed class StoriesState {}

// Initial State
final class StoriesInitial extends StoriesState {}

// Loading States
final class StoriesLoading extends StoriesState {}

final class StoriesLoadingAction extends StoriesState {}

// Success States
final class StoriesSuccess extends StoriesState {
  final FetchStoriesByCategoryEntity fetchStoriesEntity;
  StoriesSuccess(this.fetchStoriesEntity);
}

final class StoriesAddSuccess extends StoriesState {
  final AddStoryEntity addStoryEntity;
  StoriesAddSuccess(this.addStoryEntity);
}

final class StoriesUpdateSuccess extends StoriesState {
  final UpdateStoryEntity updateStoryEntity;
  StoriesUpdateSuccess(this.updateStoryEntity);
}

final class StoriesDeleteSuccess extends StoriesState {
  final DeleteStoryEntity deleteStoryEntity;
  StoriesDeleteSuccess(this.deleteStoryEntity);
}

// Search and Filter States
final class StoriesSearchResult extends StoriesState {
  final FetchStoriesByCategoryEntity searchResult;
  final String query;
  StoriesSearchResult(this.searchResult, this.query);
}

final class StoriesFilterByGenderResult extends StoriesState {
  final FetchStoriesByCategoryEntity filterResult;
  final String gender;
  StoriesFilterByGenderResult(this.filterResult, this.gender);
}

final class StoriesFilterByAgeResult extends StoriesState {
  final FetchStoriesByCategoryEntity filterResult;
  final String ageGroup;
  StoriesFilterByAgeResult(this.filterResult, this.ageGroup);
}

final class StoriesFilterByBestFriendResult extends StoriesState {
  final FetchStoriesByCategoryEntity filterResult;
  final String bestFriendGender;
  StoriesFilterByBestFriendResult(this.filterResult, this.bestFriendGender);
}

// Failure State
final class StoriesFailure extends StoriesState {
  final Exception exception;
  StoriesFailure(this.exception);
}