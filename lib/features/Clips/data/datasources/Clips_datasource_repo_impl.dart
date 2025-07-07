import 'dart:io';

import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/api/api_manager/api_manager.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/delete_clip_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/fetch_clips_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/add_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/edit_clip_entity.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'Clips_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';

@Injectable(as: ClipsDatasourceRepo)
class ClipsDatasourceRepoImpl implements ClipsDatasourceRepo {
  final ApiService apiService;

  ClipsDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<FetchClipsEntity?>> fetchClips(int storyId) {
    return executeApi(() async {
      var response = await apiService.fetchClips(
        FetchClipsRequest(storyId: storyId),
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId) {
    return executeApi(() async {
      var response = await apiService.deleteClip(
        DeleteClipRequest(clipGroupId: clipGroupId),
      );
      return response?.toEntity();
    });
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
    return executeApi(() async {
      var response = await apiService.addClip(
        storyId,
        clipText,
        sortOrder,
        1000,
        childName,
        siblingsName,
        friendsName,
        bestFriendGender,
        imageFavorite,
        image,
        audio,
      );
      return response?.toEntity();
    });
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
    return executeApi(() async {
      var response = await apiService.editClip(
        clipGroupId,
        clipText,
        1000,
        sortOrder,
        childName,
        siblingsName,
        friendsName,
        bestFriendGender,
        imageFavorite,
        image,
        audio,
      );
      return response?.toEntity();
    });
  }
}
