import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/response/fetch_clips_dto.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/request/clip_model_request.dart';
import '../../data/models/response/add_clips_dto.dart';
import '../../domain/entities/delete_clip.dart';
import '../../domain/entities/fetch_clips_entity.dart';
import '../../domain/useCases/Clips_useCase_repo.dart';

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
        if (!isClosed) {
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

////

  }

  // إضافة مقاطع جديدة
  Future<void> addClips({
    required List<ClipModelRequest> clips,
    required List<File> images,
    required List<File> audios,
    required int storyId,
  }) async {
    emit(ClipsLoading());
    try {
      final result = await _clipsUseCaseRepo.addClips(
        clips: clips,
        images: images,
        audios: audios,
      );

      if (result != null && result.status == 'success') {
        // إعادة جلب البيانات بعد الإضافة
        await fetchClips(storyId);
        emit(ClipsAddSuccess('تم إضافة المقاطع بنجاح'));
      } else {
        emit(ClipsFailure(Exception(result?.message ?? 'فشل في إضافة المقاطع')));
      }
    } catch (e) {
      emit(ClipsFailure(Exception(e.toString())));
    }
  }

  // تحديث المقاطع
  Future<void> updateClips({
    required List<ClipModelRequest> clips,
    List<File?>? images,
    List<File?>? audios,
    required int storyId,
  }) async {
    emit(ClipsLoading());
    try {
      final result = await _clipsUseCaseRepo.updateClips(
        clips: clips,
        images: images,
        audios: audios,
      );

      if (result) {
        // إعادة جلب البيانات بعد التحديث
        await fetchClips(storyId);
        emit(ClipsUpdateSuccess('تم تحديث المقاطع بنجاح'));
      } else {
        emit(ClipsFailure(Exception('فشل في تحديث المقاطع')));
      }
    } catch (e) {
      emit(ClipsFailure(Exception(e.toString())));
    }
  }

  // إعادة ترتيب المقاطع
  void reorderClips(int oldIndex, int newIndex) {
    if (_currentClipsData?.clips != null) {
       List<Clips> clips = List.from(_currentClipsData!.clips!);
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final List<Clips> item = clips.removeAt(oldIndex) as List<Clips>;
      clips.insert(newIndex, item as Clips);

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