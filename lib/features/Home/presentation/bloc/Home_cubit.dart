import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Home_useCase_repo.dart';

part 'Home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeUseCaseRepo) : super(HomeInitial());
  final HomeUseCaseRepo _homeUseCaseRepo;
}
