import 'dart:io';

import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/AudioName/data/models/request/search_name_request.dart';

import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';

import 'AudioName_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: AudioNameDatasourceRepo)
class AudioNameDatasourceRepoImpl implements AudioNameDatasourceRepo {
  final ApiService apiService;

  AudioNameDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddAudioNameEntity?>> addAudioName(
    String childName,
    File audio,
  ) {
    return executeApi(() async {
      final response = await apiService.addChildName(childName, audio);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<DeleteAudioNameEntity?>> deleteChildName(int nameAudioId) {
    return executeApi(() async {
      final response = await apiService.deleteChildName(nameAudioId);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<UpdateChildNameEntity?>> editChildName(
    int nameAudioId,
    String? name,
    File? audioFile,
  ) {
    return executeApi(() async {
      final response = await apiService.updateChildName(
        nameAudioId,
        name,
        audioFile,
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<GetNamesAudioEntity?>> fetchNamesAudio() {
   return executeApi(() async {
     final response = await apiService.fetchNamesAudio();
     return response?.toEntity();
   }
   );
  }

  @override
  Future<Result<AudioFileEmptyEntity?>> nameAudioEmpty() {
   return executeApi(() async {
     final response = await apiService.nameAudioEmpty();
     return response?.toEntity();
   }
   );
  }

  @override
  Future<Result<SearchNameAudioEntity?>> searchAudioName(String name) {
    return executeApi(() async {
      final response = await apiService.searchAudioName(SearchNameRequest(name: name));
      return response?.toEntity();

    }
    );
  }
}
