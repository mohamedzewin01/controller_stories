import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/AudioName_useCase_repo.dart';

part 'AudioName_state.dart';

@injectable
class AudioNameCubit extends Cubit<AudioNameState> {
  AudioNameCubit(this._audioNameUseCaseRepo) : super(AudioNameInitial());
  final AudioNameUseCaseRepo _audioNameUseCaseRepo;

  static AudioNameCubit get(context) => BlocProvider.of(context);

  Future<void> fetchNamesAudio() async {
    emit(GetAudioNameLoading());
    final result = await _audioNameUseCaseRepo.fetchNamesAudio();
    switch (result) {
      case Success<GetNamesAudioEntity?>():
        if (!isClosed) {
          emit(GetAudioNameSuccess(result.data!));
        }
        break;
      case Fail<GetNamesAudioEntity?>():
        if (!isClosed) {
          emit(GetAudioNameFailure(result.exception));
        }
        break;
    }
  }

  Future<void> editChildName(
    int nameAudioId,
    String name,
    File audioFile,
  ) async {
    emit(EditAudioNameLoading());
    final result = await _audioNameUseCaseRepo.editChildName(
      nameAudioId,
      name,
      audioFile,
    );
    switch (result) {
      case Success<UpdateChildNameEntity?>():
        if (!isClosed) {
          emit(EditAudioNameSuccess(result.data!));
        }
        break;
      case Fail<UpdateChildNameEntity?>():
        if (!isClosed) {
          emit(EditAudioNameFailure(result.exception));
        }
        break;
    }
  }

  Future<void> deleteChildName(int nameAudioId) async {
    emit(DeleteAudioNameLoading());
    final result = await _audioNameUseCaseRepo.deleteChildName(nameAudioId);

    switch (result) {
      case Success<DeleteAudioNameEntity?>():
        if (!isClosed) {
          emit(DeleteAudioNameSuccess(result.data!));
        }
        break;
      case Fail<DeleteAudioNameEntity?>():
        if (!isClosed) {
          emit(DeleteAudioNameFailure(result.exception));
        }
        break;
    }
  }

  Future<void> nameAudioEmpty() async {
    emit(EmptyAudioNameLoading());
    final result = await _audioNameUseCaseRepo.nameAudioEmpty();

    switch (result) {
      case Success<AudioFileEmptyEntity?>():
        if (!isClosed) {
          emit(EmptyAudioNameSuccess(result.data!));
        }
        break;
      case Fail<AudioFileEmptyEntity?>():
        if (!isClosed) {
          emit(AddAudioNameFailure(result.exception));
        }
        break;
    }
  }

  Future<void> searchAudioName(String name) async {
    emit(SearchNameLoading());
    final result = await _audioNameUseCaseRepo.searchAudioName(name);
    switch (result) {
      case Success<SearchNameAudioEntity?>():
        if (!isClosed) {
          emit(SearchNameSuccess(result.data!));
        }
        break;
      case Fail<SearchNameAudioEntity?>():
        if (!isClosed) {
          emit(SearchNameFailure(result.exception));
        }
        break;
    }
  }
}
