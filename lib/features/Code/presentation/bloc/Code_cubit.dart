import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Code_useCase_repo.dart';

part 'Code_state.dart';

@injectable
class CodeCubit extends Cubit<CodeState> {
  CodeCubit(this._codeUseCaseRepo) : super(CodeInitial());
  final CodeUseCaseRepo _codeUseCaseRepo;


  Future<void> createActiveCode(int allowedChildren, int durationMonths) async {
    emit(CodeLoading());
    final result = await _codeUseCaseRepo.createActiveCode(allowedChildren, durationMonths);
    switch (result) {
      case Success<CreateActiveCodeEntity?>():


          emit(CodeSuccess(result.data!));

        break;
      case Fail<CreateActiveCodeEntity?>():
        if (!isClosed) {
          emit(CodeFailure(result.exception));
        }
        break;
    }
  }


}
