import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/add_clip_entity.dart';
import '../../domain/entities/delete_clip.dart';
import '../../domain/entities/edit_clip_entity.dart';
import '../../domain/entities/fetch_clips_entity.dart';
import '../../domain/useCases/Clips_useCase_repo.dart';
import '../../data/models/response/fetch_clips_dto.dart';

part 'Clips_state.dart';

@injectable
class ClipsCubit extends Cubit<ClipsState> {
  ClipsCubit(this._clipsUseCaseRepo) : super(ClipsInitial());
  final ClipsUseCaseRepo _clipsUseCaseRepo;

  FetchClipsEntity? _currentClipsData;
  FetchClipsEntity? get currentClipsData => _currentClipsData;

  // جلب الـ clips الخاصة بقصة معينة
  Future<void> fetchClips(int storyId) async {
    emit(ClipsLoading());
    final result = await _clipsUseCaseRepo.fetchClips(storyId);

    switch (result) {
      case Success<FetchClipsEntity?>():
        if (!isClosed && result.data != null) {
          _currentClipsData = result.data;
          emit(ClipsFetchSuccess(result.data!));
        }
        break;
      case Fail<FetchClipsEntity?>():
        if (!isClosed) {
          emit(ClipsFailure(result.exception));
        }
        break;
    }
  }

  // حذف مقطع معين
  Future<void> deleteClip(int clipGroupId, int storyId) async {
    emit(ClipsLoading());
    final result = await _clipsUseCaseRepo.deleteClip(clipGroupId);

    switch (result) {
      case Success<DeleteClipEntity?>():
        if (!isClosed) {
          // إعادة جلب البيانات بعد الحذف
          await fetchClips(storyId);
          emit(ClipsDeleteSuccess('تم حذف المقطع بنجاح'));
        }
        break;
      case Fail<DeleteClipEntity?>():
        if (!isClosed) {
          emit(ClipsFailure(result.exception));
        }
        break;
    }
  }

  // إضافة مقطع جديد
  Future<void> addClip({
    required int storyId,
    required String clipText,
    required String sortOrder,
    required bool childName,
    required bool siblingsName,
    required bool friendsName,
    required bool bestFriendGender,
    required bool? imageFavorite,
    required File image,
    required File audio,
  }) async {
    emit(ClipsLoading());
    final result = await _clipsUseCaseRepo.addClips(
      storyId: storyId,
      clipText: clipText,
      sortOrder: sortOrder,
      childName: childName,
      siblingsName: siblingsName,
      friendsName: friendsName,
      bestFriendGender: bestFriendGender,
      imageFavorite: imageFavorite,
      image: image,
      audio: audio,
    );

    switch (result) {
      case Success<AddClipsEntity?>():
        if (!isClosed) {
          // إعادة جلب البيانات بعد الإضافة
          await fetchClips(storyId);
          emit(ClipsAddSuccess('تم إضافة المقطع بنجاح'));
        }
        break;
      case Fail<AddClipsEntity?>():
        if (!isClosed) {
          emit(ClipsFailure(result.exception));
        }
        break;
    }
  }

  // تعديل مقطع موجود
  Future<void> editClip({
    required int clipGroupId,
    required String clipText,
    required int sortOrder,
    required bool childName,
    required bool siblingsName,
    required bool friendsName,
    required bool bestFriendGender,
    required bool? imageFavorite,
    File? image,
    File? audio,
    required int storyId,
  }) async {
    emit(ClipsLoading());
    final result = await _clipsUseCaseRepo.editClips(
      clipGroupId: clipGroupId,
      clipText: clipText,
      sortOrder: sortOrder,
      childName: childName,
      siblingsName: siblingsName,
      friendsName: friendsName,
      bestFriendGender: bestFriendGender,
      imageFavorite: imageFavorite,
      image: image,
      audio: audio,
    );

    switch (result) {
      case Success<EditClipEntity?>():
        if (!isClosed) {
          // إعادة جلب البيانات بعد التعديل
          await fetchClips(storyId);
          emit(ClipsUpdateSuccess('تم تحديث المقطع بنجاح'));
        }
        break;
      case Fail<EditClipEntity?>():
        if (!isClosed) {
          emit(ClipsFailure(result.exception));
        }
        break;
    }
  }

  // إعادة ترتيب المقاطع
  void reorderClips(int oldIndex, int newIndex) {
    if (_currentClipsData?.clips != null) {
      List<Clips> clips = List.from(_currentClipsData!.clips!);
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Clips item = clips.removeAt(oldIndex);
      clips.insert(newIndex, item);

      _currentClipsData = FetchClipsEntity(
        status: _currentClipsData!.status,
        message: _currentClipsData!.message,
        count: _currentClipsData!.count,
        clips: clips,
      );

      emit(ClipsFetchSuccess(_currentClipsData!));
    }
  }
}