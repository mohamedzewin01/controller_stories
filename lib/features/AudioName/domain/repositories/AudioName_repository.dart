import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';

abstract class AudioNameRepository {
  Future<Result<AddAudioNameEntity?>>addAudioName(String childName,File audio);
  Future<Result<DeleteAudioNameEntity?>>deleteChildName(int nameAudioId);
  Future<Result<UpdateChildNameEntity?>>editChildName(int nameAudioId,String? name,File? audioFile);
  Future<Result<AudioFileEmptyEntity?>>nameAudioEmpty();
  Future<Result<SearchNameAudioEntity?>>searchAudioName(String name);
  Future<Result<GetNamesAudioEntity?>>fetchNamesAudio();

}
