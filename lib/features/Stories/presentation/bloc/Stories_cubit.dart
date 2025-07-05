import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Stories_useCase_repo.dart';

part 'Stories_state.dart';

@injectable
class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit(this._storiesUseCaseRepo) : super(StoriesInitial());
  final StoriesUseCaseRepo _storiesUseCaseRepo;
}
