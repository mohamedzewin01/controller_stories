import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/AudioName/data/datasources/AudioName_datasource_repo.dart';
import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/AudioName_repository.dart';

@Injectable(as: AudioNameRepository)
class AudioNameRepositoryImpl implements AudioNameRepository {
  final AudioNameDatasourceRepo audioNameDatasourceRepo;
  AudioNameRepositoryImpl(this.audioNameDatasourceRepo);
  @override
  Future<Result<AddAudioNameEntity?>> addAudioName(String childName, File audio) {
    return audioNameDatasourceRepo.addAudioName(childName, audio);
  }

  @override
  Future<Result<DeleteAudioNameEntity?>> deleteChildName(int nameAudioId) {
    return audioNameDatasourceRepo.deleteChildName(nameAudioId);
  }

  @override
  Future<Result<UpdateChildNameEntity?>> editChildName(int nameAudioId, String name, File audioFile) {
    return audioNameDatasourceRepo.editChildName(nameAudioId, name, audioFile);
  }

  @override
  Future<Result<GetNamesAudioEntity?>> fetchNamesAudio() {
    return audioNameDatasourceRepo.fetchNamesAudio();
  }

  @override
  Future<Result<AudioFileEmptyEntity?>> nameAudioEmpty() {
  return audioNameDatasourceRepo.nameAudioEmpty();
  }

  @override
  Future<Result<SearchNameAudioEntity?>> searchAudioName(String name) {
    return audioNameDatasourceRepo.searchAudioName(name);
  }
  // implementation
}
