import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/RequestStory_useCase_repo.dart';

part 'RequestStory_state.dart';

@injectable
class RequestStoryCubit extends Cubit<RequestStoryState> {
  RequestStoryCubit(this._requestStoryUseCaseRepo)
      : super(RequestStoryInitial());
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


  Future<void> addReplies({
    required int requestId,
    required String replyText,
    int? attachedStoryId,
  }) async {

    emit(AddRepliesLoading());
    var result = await _requestStoryUseCaseRepo.addReplies(
      requestId: requestId,
      replyText: replyText,
      attachedStoryId: attachedStoryId, // إضافة المعامل المفقود
    );
    switch (result) {
      case Success<AddRepliesEntity?>():
        if (!isClosed && result.data != null) {
          emit(AddRepliesSuccess(result.data!));
        }
        break;
      case Fail<AddRepliesEntity?>():
        if (!isClosed) {
          emit(AddRepliesFailure(result.exception));
        }
        break;
    }
  }

  Future<void> getAllStories() async {
    emit(GetAllStoriesLoading());
    var result = await _requestStoryUseCaseRepo.getAllStories();
    switch (result) {
      case Success<GetAllStoriesEntity?>():
        if (!isClosed && result.data != null) {
          emit(GetAllStoriesSuccess(result.data!));
        }
        break;
      case Fail<GetAllStoriesEntity?>():
        if (!isClosed) {
          emit(GetAllStoriesFailure(result.exception));
        }
        break;
    }
  }
}