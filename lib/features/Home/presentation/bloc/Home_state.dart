part of 'Home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeSuccess extends HomeState {}
final class HomeFailure extends HomeState {
  final Exception exception;

  HomeFailure(this.exception);
}
