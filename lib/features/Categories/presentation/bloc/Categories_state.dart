part of 'Categories_cubit.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}
final class CategoriesLoading extends CategoriesState {}
final class CategoriesSuccess extends CategoriesState {
  final FetchCategoriesEntity fetchCategoriesEntity;
  CategoriesSuccess(this.fetchCategoriesEntity);
}
final class CategoriesFailure extends CategoriesState {
  final Exception exception;

  CategoriesFailure(this.exception);
}
