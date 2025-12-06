part of 'Code_cubit.dart';

@immutable
sealed class CodeState {}

final class CodeInitial extends CodeState {}
final class CodeLoading extends CodeState {}
final class CodeSuccess extends CodeState {
  final CreateActiveCodeEntity? createActiveCodeEntity;

  CodeSuccess(this.createActiveCodeEntity);
}
final class CodeFailure extends CodeState {
  final Exception exception;

  CodeFailure(this.exception);
}


