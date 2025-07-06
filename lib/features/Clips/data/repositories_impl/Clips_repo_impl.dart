import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/datasources/Clips_datasource_repo.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/add_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/edit_clip_entity.dart';
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
  Future<Result<AddClipsEntity?>> addClips({
    required int storyId,
    required String? clipText,
    required String? sortOrder,
    required bool? childName,
    required bool? siblingsName,
    required bool? friendsName,
    required bool? bestFriendGender,
    required File? image,
    required File? audio,
  }) {
    return clipsDatasourceRepo.addClips(
      storyId: storyId,
      clipText: clipText,
      sortOrder: sortOrder,
      childName: childName,
      siblingsName: siblingsName,
      friendsName: friendsName,
      bestFriendGender: bestFriendGender,
      image: image,
      audio: audio,
    );
  }

  @override
  Future<Result<EditClipEntity?>> editClips({
    required int clipGroupId,
    required String? clipText,
    required int? sortOrder,
    required bool? childName,
    required bool? siblingsName,
    required bool? friendsName,
    required bool? bestFriendGender,
    required File? image,
    required File? audio,
  }) {
    return clipsDatasourceRepo.editClips(
      clipGroupId: clipGroupId,
      clipText: clipText,
      sortOrder: sortOrder,
      childName: childName,
      siblingsName: siblingsName,
      friendsName: friendsName,
      bestFriendGender: bestFriendGender,
      image: image,
      audio: audio,
    );
  }
}
