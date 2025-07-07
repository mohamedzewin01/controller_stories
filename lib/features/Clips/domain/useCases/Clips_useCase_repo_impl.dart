import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/add_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/edit_clip_entity.dart';

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
  Future<Result<AddClipsEntity?>> addClips({
    required int storyId,
    required String? clipText,
    required String? sortOrder,
    required bool? childName,
    required bool? siblingsName,
    required bool? friendsName,
    required bool? bestFriendGender,
    required bool? imageFavorite,
    required File? image,
    required File? audio,
  }) {
    return repository.addClips(
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
    required bool? imageFavorite,
    required File? image,
    required File? audio,
  }) {
    return repository.editClips(
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
  }



}
