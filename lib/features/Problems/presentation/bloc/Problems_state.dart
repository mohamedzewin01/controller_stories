part of 'Problems_cubit.dart';

@immutable
sealed class ProblemsState {}

final class ProblemsInitial extends ProblemsState {}
final class GetProblemsLoading extends ProblemsState {}
final class GetProblemsSuccess extends ProblemsState {
  final GetProblemsEntity? data;
  GetProblemsSuccess(this.data);
}
final class GetProblemsFailure extends ProblemsState {
  final Exception exception;

  GetProblemsFailure(this.exception);
}


final class AddProblemsLoading extends ProblemsState {}
final class AddProblemsSuccess extends ProblemsState {
  final AddProblemEntity? data;
  AddProblemsSuccess(this.data);
}
final class AddProblemsFailure extends ProblemsState {
  final Exception exception;

  AddProblemsFailure(this.exception);
}


final class EditProblemsLoading extends ProblemsState {}
final class EditProblemsSuccess extends ProblemsState {
  final UpdateProblemEntity? data;
  EditProblemsSuccess(this.data);
}
final class EditProblemsFailure extends ProblemsState {
  final Exception exception;

  EditProblemsFailure(this.exception);
}


final class DeleteProblemsLoading extends ProblemsState {}
final class DeleteProblemsSuccess extends ProblemsState {
  final DeleteProblemEntity? data;
  DeleteProblemsSuccess(this.data);
}
final class DeleteProblemsFailure extends ProblemsState {
  final Exception exception;

  DeleteProblemsFailure(this.exception);
}