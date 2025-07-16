part of 'RequestStory_cubit.dart';

@immutable
sealed class RequestStoryState {}

final class RequestStoryInitial extends RequestStoryState {}
final class RequestStoryLoading extends RequestStoryState {}
final class RequestStorySuccess extends RequestStoryState {
  final GetRequestStoryEntity? entity;
  RequestStorySuccess(this.entity);
}
final class RequestStoryFailure extends RequestStoryState {
  final Exception exception;

  RequestStoryFailure(this.exception);
}
