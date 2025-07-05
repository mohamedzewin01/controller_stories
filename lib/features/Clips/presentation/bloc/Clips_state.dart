part of 'Clips_cubit.dart';

@immutable
sealed class ClipsState {}

final class ClipsInitial extends ClipsState {}
final class ClipsLoading extends ClipsState {}
final class ClipsSuccess extends ClipsState {}
final class ClipsFailure extends ClipsState {
  final Exception exception;

  ClipsFailure(this.exception);
}
