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

final class AddRepliesLoading extends RequestStoryState {}
final class AddRepliesSuccess extends RequestStoryState {
  final AddRepliesEntity? entity;
  AddRepliesSuccess(this.entity);
}
final class AddRepliesFailure extends RequestStoryState {
  final Exception exception;

  AddRepliesFailure(this.exception);
}

final class GetAllStoriesLoading extends RequestStoryState {}
final class GetAllStoriesSuccess extends RequestStoryState {
  final GetAllStoriesEntity? entity;
  GetAllStoriesSuccess(this.entity);
}
final class GetAllStoriesFailure extends RequestStoryState {
  final Exception exception;

  GetAllStoriesFailure(this.exception);
}
