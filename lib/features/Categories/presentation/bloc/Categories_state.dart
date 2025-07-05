part of 'Categories_cubit.dart';

@immutable
sealed class CategoriesState {}

// Initial State
final class CategoriesInitial extends CategoriesState {}

// Loading States
final class CategoriesLoading extends CategoriesState {}

final class CategoriesLoadingAction extends CategoriesState {}

// Success States
final class CategoriesSuccess extends CategoriesState {
  final FetchCategoriesEntity fetchCategoriesEntity;
  CategoriesSuccess(this.fetchCategoriesEntity);
}

final class CategoriesInsertSuccess extends CategoriesState {
  final InsertCategoryEntity insertCategoryEntity;
  CategoriesInsertSuccess(this.insertCategoryEntity);
}

final class CategoriesUpdateSuccess extends CategoriesState {
  final UpdateCategoryEntity updateCategoryEntity;
  CategoriesUpdateSuccess(this.updateCategoryEntity);
}

final class CategoriesDeleteSuccess extends CategoriesState {
  final DeleteCategoryEntity deleteCategoryEntity;
  CategoriesDeleteSuccess(this.deleteCategoryEntity);
}

// Search and Filter States
final class CategoriesSearchResult extends CategoriesState {
  final FetchCategoriesEntity searchResult;
  final String query;
  CategoriesSearchResult(this.searchResult, this.query);
}

final class CategoriesFilterResult extends CategoriesState {
  final FetchCategoriesEntity filterResult;
  final bool isActive;
  CategoriesFilterResult(this.filterResult, this.isActive);
}

// Failure State
final class CategoriesFailure extends CategoriesState {
  final Exception exception;
  CategoriesFailure(this.exception);
}