part of 'AudioName_cubit.dart';

@immutable
sealed class AudioNameState {}

final class AudioNameInitial extends AudioNameState {}
final class GetAudioNameLoading extends AudioNameState {}
final class GetAudioNameSuccess extends AudioNameState {
  final GetNamesAudioEntity getNamesAudioEntity;
  GetAudioNameSuccess(this.getNamesAudioEntity);
}
final class GetAudioNameFailure extends AudioNameState {
  final Exception exception;

  GetAudioNameFailure(this.exception);
}
///-
final class EditAudioNameLoading extends AudioNameState {}
final class EditAudioNameSuccess extends AudioNameState {
  final UpdateChildNameEntity editChildNameEntity;
  EditAudioNameSuccess(this.editChildNameEntity);
}
final class EditAudioNameFailure extends AudioNameState {
  final Exception exception;

  EditAudioNameFailure(this.exception);
}
///-
final class DeleteAudioNameLoading extends AudioNameState {}
final class DeleteAudioNameSuccess extends AudioNameState {
  final DeleteAudioNameEntity deleteAudioNameEntity;
  DeleteAudioNameSuccess(this.deleteAudioNameEntity);
}
final class DeleteAudioNameFailure extends AudioNameState {
  final Exception exception;

  DeleteAudioNameFailure(this.exception);
}
///-
final class EmptyAudioNameLoading extends AudioNameState {}
final class EmptyAudioNameSuccess extends AudioNameState {
  final AudioFileEmptyEntity audioFileEmptyEntity;
  EmptyAudioNameSuccess(this.audioFileEmptyEntity);
}
final class EmptyAudioNameFailure extends AudioNameState {
  final Exception exception;

  EmptyAudioNameFailure(this.exception);
}
///-
final class SearchNameLoading extends AudioNameState {}
final class SearchNameSuccess extends AudioNameState {
  final SearchNameAudioEntity searchNameAudioEntity;
  SearchNameSuccess(this.searchNameAudioEntity);
}
final class SearchNameFailure extends AudioNameState {
  final Exception exception;

  SearchNameFailure(this.exception);
}
///-
final class AddAudioNameLoading extends AudioNameState {}
final class AddAudioNameSuccess extends AudioNameState {
  final AddAudioNameEntity addAudioNameEntity;
  AddAudioNameSuccess(this.addAudioNameEntity);
}
final class AddAudioNameFailure extends AudioNameState {
  final Exception exception;

  AddAudioNameFailure(this.exception);
}