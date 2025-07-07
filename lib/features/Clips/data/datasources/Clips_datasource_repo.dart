import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/add_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/edit_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';

abstract class ClipsDatasourceRepo {
  Future<Result<FetchClipsEntity?>> fetchClips(int storyId);

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
  });
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
  });
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId);
}
