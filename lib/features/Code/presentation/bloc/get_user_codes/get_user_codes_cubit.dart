import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:controller_stories/features/Code/domain/useCases/Code_useCase_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'get_user_codes_state.dart';

@injectable
class GetUserCodesCubit extends Cubit<GetUserCodesState> {
  GetUserCodesCubit(this._codeUseCaseRepo) : super(GetUserCodesInitial());
  final CodeUseCaseRepo _codeUseCaseRepo;

  Future<void> getUserCodes(String filter, int page) async {
    emit(GetUserCodesLoading());
    final result = await _codeUseCaseRepo.getUserCodes(filter, page);
    switch (result) {
      case Success<GetUserCodesEntity?>():
        emit(GetUserCodesSuccess(result.data!));
        break;
      case Fail<GetUserCodesEntity?>():
        emit(GetUserCodesError(result.exception));
        break;
    }
  }

}
