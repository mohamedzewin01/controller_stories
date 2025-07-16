import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/RequestStory_useCase_repo.dart';

part 'RequestStory_state.dart';

@injectable
class RequestStoryCubit extends Cubit<RequestStoryState> {
  RequestStoryCubit(this._requestStoryUseCaseRepo) : super(RequestStoryInitial());
  final RequestStoryUseCaseRepo _requestStoryUseCaseRepo;


  Future<void> getRequestStories() async {
    emit(RequestStoryLoading());
    var result = await _requestStoryUseCaseRepo.getRequestStories();
    switch (result) {
      case Success<GetRequestStoryEntity?>():
        if (!isClosed && result.data != null) {

          emit(RequestStorySuccess(result.data!));
        }
        break;
      case Fail<GetRequestStoryEntity?>():
        if (!isClosed) {
          emit(RequestStoryFailure(result.exception));
        }
        break;
    }
  }
}
