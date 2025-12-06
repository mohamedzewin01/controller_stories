part of 'get_user_codes_cubit.dart';

@immutable
sealed class GetUserCodesState {}

final class GetUserCodesInitial extends GetUserCodesState {}
final class GetUserCodesLoading extends GetUserCodesState {}
final class GetUserCodesSuccess extends GetUserCodesState {
  final GetUserCodesEntity? data;
  GetUserCodesSuccess(this.data);
}
final class GetUserCodesError extends GetUserCodesState {
  final Exception exception;
  GetUserCodesError( this.exception);
}

