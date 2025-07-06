part of 'Clips_cubit.dart';

@immutable
sealed class ClipsState {}

final class ClipsInitial extends ClipsState {}

final class ClipsLoading extends ClipsState {}

final class ClipsFetchSuccess extends ClipsState {
  final FetchClipsEntity clipsData;
  ClipsFetchSuccess(this.clipsData);
}

final class ClipsDeleteSuccess extends ClipsState {
  final String message;
  ClipsDeleteSuccess(this.message);
}

final class ClipsAddSuccess extends ClipsState {
  final String message;
  ClipsAddSuccess(this.message);
}

final class ClipsUpdateSuccess extends ClipsState {
  final String message;
  ClipsUpdateSuccess(this.message);
}

final class ClipsFailure extends ClipsState {
  final Exception exception;
  ClipsFailure(this.exception);
}