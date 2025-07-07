part of 'Problems_cubit.dart';

@immutable
sealed class ProblemsState {}

final class ProblemsInitial extends ProblemsState {}
final class ProblemsLoading extends ProblemsState {}
final class ProblemsSuccess extends ProblemsState {}
final class ProblemsFailure extends ProblemsState {
  final Exception exception;

  ProblemsFailure(this.exception);
}
