part of 'AudioName_cubit.dart';

@immutable
sealed class AudioNameState {}

final class AudioNameInitial extends AudioNameState {}
final class AudioNameLoading extends AudioNameState {}
final class AudioNameSuccess extends AudioNameState {}
final class AudioNameFailure extends AudioNameState {
  final Exception exception;

  AudioNameFailure(this.exception);
}
