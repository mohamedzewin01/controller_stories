import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';

import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';

import '../repositories/Clips_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Clips_useCase_repo.dart';

@Injectable(as: ClipsUseCaseRepo)
class ClipsUseCase implements ClipsUseCaseRepo {
  final ClipsRepository repository;

  ClipsUseCase(this.repository);

  @override
  Future<Result<FetchClipsEntity?>> fetchClips(int storyId) {
    return repository.fetchClips(storyId);
  }

  @override
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId) {
    return repository.deleteClip(clipGroupId);
  }

  @override
  Future<AddClipsDto?> addClips({
    required List<ClipModelRequest> clips,
    required List<File> images,
    required List<File> audios,
  }) {
    return repository.addClips(clips: clips, images: images, audios: audios);
  }

  @override
  Future<bool> updateClips({
    required List<ClipModelRequest> clips,
    List<File?>? images,
    List<File?>? audios,
  }) {
    return repository.updateClips(clips: clips, images: images, audios: audios);
  }
}
