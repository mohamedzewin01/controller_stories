import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';

import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';

import '../repositories/AudioName_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/AudioName_useCase_repo.dart';

@Injectable(as: AudioNameUseCaseRepo)
class AudioNameUseCase implements AudioNameUseCaseRepo {
  final AudioNameRepository repository;

  AudioNameUseCase(this.repository);

  @override
  Future<Result<AddAudioNameEntity?>> addAudioName(String childName, File audio) {
    return repository.addAudioName(childName, audio);
  }

  @override
  Future<Result<DeleteAudioNameEntity?>> deleteChildName(int nameAudioId) {
   return repository.deleteChildName(nameAudioId);
  }

  @override
  Future<Result<UpdateChildNameEntity?>> editChildName(int nameAudioId, String? name, File? audioFile) {
   return repository.editChildName(nameAudioId, name, audioFile);
  }

  @override
  Future<Result<GetNamesAudioEntity?>> fetchNamesAudio() {
   return repository.fetchNamesAudio();
  }

  @override
  Future<Result<AudioFileEmptyEntity?>> nameAudioEmpty() {
   return repository.nameAudioEmpty();
  }

  @override
  Future<Result<SearchNameAudioEntity?>> searchAudioName(String name) {
   return repository.searchAudioName(name);
  }

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
