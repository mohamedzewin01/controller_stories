import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/datasources/Clips_datasource_repo.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/Clips_repository.dart';

@Injectable(as: ClipsRepository)
class ClipsRepositoryImpl implements ClipsRepository {
  final ClipsDatasourceRepo clipsDatasourceRepo;

  ClipsRepositoryImpl(this.clipsDatasourceRepo);

  @override
  Future<Result<FetchClipsEntity?>> fetchClips(int storyId) {
    return clipsDatasourceRepo.fetchClips(storyId);
  }

  @override
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId) {
    return clipsDatasourceRepo.deleteClip(clipGroupId);
  }

  @override
  Future<AddClipsDto?> addClips({required List<ClipModelRequest> clips, required List<File> images, required List<File> audios}) {
 return clipsDatasourceRepo.addClips(clips: clips, images: images, audios: audios);
  }

  @override
  Future<bool> updateClips({required List<ClipModelRequest> clips, List<File?>? images, List<File?>? audios}) {
    return clipsDatasourceRepo.updateClips(clips: clips, images: images, audios: audios);
  }
}
